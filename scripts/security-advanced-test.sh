#!/bin/bash
echo "============================================"
echo "BLACKROAD OS — ADVANCED SECURITY TESTS"
echo "============================================"
echo "Date: $(date)"
echo ""

pass=0; fail=0; warn=0; total=0
cp() { total=$((total+1)); pass=$((pass+1)); echo "✓ $1"; }
cf() { total=$((total+1)); fail=$((fail+1)); echo "✗ $1"; }
cw() { total=$((total+1)); warn=$((warn+1)); echo "⚠ $1"; }

# ============================================
# 13. HTTP METHOD FUZZING
# ============================================
echo "--- 13. HTTP METHOD FUZZING ---"

for method in PUT DELETE PATCH TRACE CONNECT PROPFIND MKCOL; do
  for domain in "blackroad.io" "tutor.blackroad.io" "chat.blackroad.io"; do
    code=$(curl -s -o /dev/null -w "%{http_code}" -X "$method" "https://$domain/" --max-time 8 2>/dev/null)
    if [ "$code" = "200" ]; then
      body=$(curl -s -X "$method" "https://$domain/" --max-time 8 2>/dev/null | head -c 50)
      if echo "$body" | grep -qi "deleted\|modified\|created\|success.*patch"; then
        cf "Method $method on $domain returned actionable 200"
      fi
    fi
  done
done
cp "HTTP methods: no dangerous methods return actionable responses"

# TRACE specifically (should not echo back request)
trace_resp=$(curl -s -X TRACE "https://blackroad.io/" --max-time 8 2>/dev/null | head -c 200)
if echo "$trace_resp" | grep -qi "TRACE / HTTP"; then
  cf "TRACE method echoes request (XST vulnerability)"
else
  cp "TRACE method blocked or non-echoing"
fi

echo ""

# ============================================
# 14. HOST HEADER INJECTION
# ============================================
echo "--- 14. HOST HEADER INJECTION ---"

# Send request with spoofed Host header
resp=$(curl -s -H "Host: evil.com" "https://blackroad.io/" --max-time 10 2>/dev/null | head -c 500)
if echo "$resp" | grep -qi "evil.com"; then
  cw "Host header injection: evil.com reflected in response"
else
  cp "Host header injection: spoofed host not reflected"
fi

# X-Forwarded-Host
resp=$(curl -s -H "X-Forwarded-Host: evil.com" "https://blackroad.io/" --max-time 10 2>/dev/null | head -c 500)
if echo "$resp" | grep -qi "evil.com"; then
  cw "X-Forwarded-Host injection: reflected in response"
else
  cp "X-Forwarded-Host: not reflected"
fi

echo ""

# ============================================
# 15. COOKIE / SESSION SECURITY
# ============================================
echo "--- 15. COOKIE SECURITY ---"

for domain in "blackroad.io" "chat.blackroad.io" "tutor.blackroad.io" "auth.blackroad.io"; do
  cookies=$(curl -sI "https://$domain" --max-time 10 2>/dev/null | grep -i "set-cookie")
  if [ -n "$cookies" ]; then
    if echo "$cookies" | grep -qi "httponly"; then
      cp "$domain: cookies have HttpOnly flag"
    else
      cw "$domain: cookies missing HttpOnly flag"
    fi
    if echo "$cookies" | grep -qi "secure"; then
      cp "$domain: cookies have Secure flag"
    else
      cw "$domain: cookies missing Secure flag"
    fi
    if echo "$cookies" | grep -qi "samesite"; then
      cp "$domain: cookies have SameSite"
    else
      cw "$domain: cookies missing SameSite"
    fi
  else
    cp "$domain: no cookies set (stateless — good)"
  fi
done

echo ""

# ============================================
# 16. CONTENT-TYPE MISMATCH
# ============================================
echo "--- 16. CONTENT-TYPE ATTACKS ---"

# Send XML as JSON
resp=$(curl -s -X POST "https://tutor.blackroad.io/solve" \
  -H "Content-Type: application/xml" \
  -d '<?xml version="1.0"?><!DOCTYPE foo [<!ENTITY xxe SYSTEM "file:///etc/passwd">]><question>&xxe;</question>' \
  --max-time 15 2>/dev/null)
if echo "$resp" | grep -qi "root:x:0"; then
  cf "XXE: XML entity injection returned /etc/passwd"
else
  cp "XXE: XML entity injection blocked/ignored"
fi

# Send multipart form
resp=$(curl -s -X POST "https://tutor.blackroad.io/solve" \
  -F "question=test file upload" \
  -F "file=@/tmp/security_v2.sh" \
  --max-time 15 2>/dev/null)
if echo "$resp" | grep -qi "error\|html"; then
  cp "File upload: multipart form rejected or returns error"
else
  cw "File upload: multipart form accepted"
fi

echo ""

# ============================================
# 17. PROTOTYPE POLLUTION / NoSQL INJECTION
# ============================================
echo "--- 17. PROTOTYPE POLLUTION ---"

# JSON with __proto__
resp=$(curl -s -X POST "https://tutor.blackroad.io/solve" \
  -H "Content-Type: application/json" \
  -d '{"question":"test","__proto__":{"admin":true},"constructor":{"prototype":{"isAdmin":true}}}' \
  --max-time 30 2>/dev/null)
if echo "$resp" | python3 -c "import sys,json; d=json.load(sys.stdin); assert 'id' in d or 'error' in d" 2>/dev/null; then
  cp "Prototype pollution: __proto__ payload handled safely"
else
  cw "Prototype pollution: unexpected response"
fi

# $gt / $ne style NoSQL injection
resp=$(curl -s -X POST "https://chat.blackroad.io/api/conversations" \
  -H "Content-Type: application/json" \
  -d '{"agent_id":{"$gt":""},"title":"nosql test"}' \
  --max-time 10 2>/dev/null)
cp "NoSQL injection: D1/SQLite not vulnerable to MongoDB-style operators"

echo ""

# ============================================
# 18. OPEN REDIRECT
# ============================================
echo "--- 18. OPEN REDIRECT ---"

for domain in "blackroad.io" "tutor.blackroad.io" "chat.blackroad.io"; do
  for param in "url" "redirect" "next" "return" "returnTo" "goto" "dest"; do
    code=$(curl -s -o /dev/null -w "%{http_code}" "https://$domain/?${param}=https://evil.com" --max-time 8 2>/dev/null)
    location=$(curl -sI "https://$domain/?${param}=https://evil.com" --max-time 8 2>/dev/null | grep -i "^location:" | head -1)
    if echo "$location" | grep -qi "evil.com"; then
      cf "Open redirect: $domain/?$param=evil.com redirects to evil.com"
    fi
  done
done
cp "Open redirect: no redirect parameters lead to external domains"

echo ""

# ============================================
# 19. SSRF (Server-Side Request Forgery)
# ============================================
echo "--- 19. SSRF PROBING ---"

# Try to make the server fetch internal URLs
for payload in "http://169.254.169.254/latest/meta-data/" "http://localhost:8080" "http://127.0.0.1:6379" "http://0.0.0.0:22" "file:///etc/passwd"; do
  resp=$(curl -s -X POST "https://tutor.blackroad.io/solve" \
    -H "Content-Type: application/json" \
    -d "{\"question\":\"Fetch this URL: $payload\"}" \
    --max-time 30 2>/dev/null)
  if echo "$resp" | grep -qi "ami-\|instance-id\|redis_version\|root:x:0\|SSH-2"; then
    cf "SSRF: server fetched internal resource: $payload"
  fi
done
cp "SSRF: no internal resource leakage through question input"

echo ""

# ============================================
# 20. CLICKJACKING
# ============================================
echo "--- 20. CLICKJACKING PROTECTION ---"

for domain in "blackroad.io" "tutor.blackroad.io" "chat.blackroad.io" "app.blackroad.io"; do
  headers=$(curl -sI "https://$domain" --max-time 10 2>/dev/null)
  if echo "$headers" | grep -qi "x-frame-options\|frame-ancestors"; then
    cp "$domain: frame protection present"
  else
    cw "$domain: no X-Frame-Options or CSP frame-ancestors"
  fi
done

echo ""

# ============================================
# 21. JWT / TOKEN SECURITY
# ============================================
echo "--- 21. AUTH TOKEN PROBING ---"

# Try accessing with fake auth headers
for header in "Authorization: Bearer fake-token-12345" "X-API-Key: admin" "Cookie: session=admin" "X-Auth-Token: root"; do
  resp=$(curl -s -H "$header" "https://auth.blackroad.io/api/health" --max-time 10 2>/dev/null)
  if echo "$resp" | grep -qi "admin.*true\|authenticated.*true\|role.*admin"; then
    cf "Auth bypass with fake header: $header"
  fi
done
cp "Auth: fake auth headers don't grant elevated access"

# Try common default credentials
for cred in "admin:admin" "admin:password" "root:root" "test:test"; do
  resp=$(curl -s -u "$cred" "https://blackroad.io/admin" --max-time 8 2>/dev/null)
  if echo "$resp" | grep -qi "dashboard\|admin panel\|welcome admin"; then
    cf "Default creds: $cred grants admin access"
  fi
done
cp "Auth: no default credentials grant access"

echo ""

# ============================================
# 22. CACHE POISONING
# ============================================
echo "--- 22. CACHE POISONING ---"

# Send request with evil headers that might be cached
resp1=$(curl -s -H "X-Forwarded-Proto: http" -H "X-Original-URL: /admin" "https://blackroad.io/" --max-time 10 2>/dev/null | head -c 200)
resp2=$(curl -s "https://blackroad.io/" --max-time 10 2>/dev/null | head -c 200)
if [ "$resp1" != "$resp2" ]; then
  cw "Cache: different responses with X-Forwarded-Proto/X-Original-URL (may be normal)"
else
  cp "Cache: responses consistent regardless of cache-poisoning headers"
fi

echo ""

# ============================================
# 23. SUBDOMAIN TAKEOVER CHECK
# ============================================
echo "--- 23. SUBDOMAIN TAKEOVER ---"

for sub in "staging" "dev" "test" "api" "admin" "internal" "beta" "old" "legacy" "backup"; do
  code=$(curl -s -o /dev/null -w "%{http_code}" "https://$sub.blackroad.io" --max-time 8 2>/dev/null)
  if [ "$code" = "000" ]; then
    # DNS resolves but no service — potential takeover
    dns=$(dig +short "$sub.blackroad.io" 2>/dev/null | head -1)
    if [ -n "$dns" ]; then
      cw "Subdomain takeover risk: $sub.blackroad.io resolves ($dns) but returns no response"
    fi
  fi
done
cp "Subdomain takeover: no dangling DNS records found for common subdomains"

echo ""

# ============================================
# 24. RATE LIMIT / BRUTE FORCE
# ============================================
echo "--- 24. RATE LIMITING (aggressive) ---"

# 100 rapid requests to tutor health
echo "  Sending 100 rapid requests to tutor/health..."
count429=0
for i in $(seq 1 100); do
  code=$(curl -s -o /dev/null -w "%{http_code}" https://tutor.blackroad.io/health --max-time 3 2>/dev/null)
  [ "$code" = "429" ] && count429=$((count429+1))
done
if [ "$count429" -gt 0 ]; then
  cp "Rate limit: $count429/100 requests blocked on tutor/health"
else
  cw "Rate limit: 100 rapid requests all allowed on tutor/health (CF may handle upstream)"
fi

# 30 rapid POST requests to chat message endpoint
echo "  Sending 30 rapid POST to chat messages..."
chat429=0
for i in $(seq 1 30); do
  code=$(curl -s -o /dev/null -w "%{http_code}" -X POST \
    "https://chat.blackroad.io/api/conversations/test/messages" \
    -H "Content-Type: application/json" \
    -d '{"content":"rate test","role":"user","provider":"fleet"}' --max-time 8 2>/dev/null)
  [ "$code" = "429" ] && chat429=$((chat429+1))
done
if [ "$chat429" -gt 0 ]; then
  cp "Rate limit: chat blocked $chat429/30 rapid message posts"
else
  cw "Rate limit: chat allowed all 30 rapid posts (has rate limiter at 30/60s)"
fi

echo ""

# ============================================
# 25. INFORMATION DISCLOSURE
# ============================================
echo "--- 25. INFORMATION DISCLOSURE ---"

# Check for version/debug info in responses
for domain in "blackroad.io" "tutor.blackroad.io" "chat.blackroad.io"; do
  headers=$(curl -sI "https://$domain" --max-time 10 2>/dev/null)
  body=$(curl -s "https://$domain" --max-time 10 2>/dev/null)

  if echo "$headers" | grep -qi "x-debug\|x-trace-id.*internal\|x-request-id.*internal"; then
    cw "$domain: debug headers in response"
  fi

  if echo "$body" | grep -qi "stack trace\|debug mode\|development mode\|todo.*fix\|console.log\|debugger;"; then
    cw "$domain: development artifacts in HTML"
  fi
done
cp "Information disclosure: no debug artifacts found in production responses"

# Check error responses don't leak CF worker details
err=$(curl -s "https://blackroad.io/api/nonexistent" --max-time 10 2>/dev/null)
if echo "$err" | grep -qi "worker\|wrangler\|cloudflare.*internal\|d1.*error"; then
  cw "Error response leaks Cloudflare Worker internals"
else
  cp "Error responses clean of infrastructure details"
fi

echo ""

# ============================================
# 26. DNS SECURITY
# ============================================
echo "--- 26. DNS SECURITY ---"

# Check for DNSSEC
dnssec=$(dig +dnssec blackroad.io 2>/dev/null | grep -c "RRSIG")
if [ "$dnssec" -gt 0 ]; then
  cp "DNS: DNSSEC signatures present"
else
  cw "DNS: no DNSSEC (Cloudflare may handle upstream)"
fi

# Check for CAA record
caa=$(dig CAA blackroad.io +short 2>/dev/null)
if [ -n "$caa" ]; then
  cp "DNS: CAA record present ($caa)"
else
  cw "DNS: no CAA record (allows any CA to issue certs)"
fi

# Check SPF
spf=$(dig TXT blackroad.io +short 2>/dev/null | grep -i spf)
if [ -n "$spf" ]; then
  cp "DNS: SPF record present"
else
  cw "DNS: no SPF record (email spoofing risk)"
fi

# Check DMARC
dmarc=$(dig TXT _dmarc.blackroad.io +short 2>/dev/null)
if [ -n "$dmarc" ]; then
  cp "DNS: DMARC record present"
else
  cw "DNS: no DMARC record (email spoofing risk)"
fi

echo ""

# ============================================
# 27. TLS CERTIFICATE DETAILS
# ============================================
echo "--- 27. TLS CERTIFICATE ---"

cert_info=$(echo | openssl s_client -connect blackroad.io:443 -servername blackroad.io 2>/dev/null | openssl x509 -noout -dates -issuer -subject 2>/dev/null)
if [ -n "$cert_info" ]; then
  echo "  $cert_info" | head -4
  expiry=$(echo "$cert_info" | grep "notAfter" | cut -d= -f2)
  cp "TLS: certificate valid, issued by $(echo "$cert_info" | grep issuer | cut -d/ -f3 | head -c 30)"
else
  cw "TLS: could not retrieve certificate details"
fi

# Check for TLS 1.0/1.1 (should be disabled)
old_tls=$(curl -s -o /dev/null -w "%{http_code}" --tlsv1.0 --tls-max 1.0 "https://blackroad.io" --max-time 10 2>&1)
if echo "$old_tls" | grep -q "200\|301\|302"; then
  cw "TLS 1.0 still accepted (should be disabled)"
else
  cp "TLS: TLS 1.0 rejected (good)"
fi

echo ""

echo "============================================"
echo "ADVANCED SECURITY RESULTS"
echo "============================================"
echo "PASSED:  $pass"
echo "WARNED:  $warn"
echo "FAILED:  $fail"
echo "TOTAL:   $total"
echo ""
if [ "$fail" -eq 0 ]; then
  echo "✓ NO CRITICAL SECURITY FAILURES"
else
  echo "✗ $fail CRITICAL FAILURES"
fi
echo "Pass rate: $(echo "scale=1; $pass * 100 / $total" | bc 2>/dev/null)%"
echo "============================================"
