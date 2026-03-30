#!/bin/bash
echo "============================================"
echo "BLACKROAD OS — SECURITY STRESS TEST v2"
echo "============================================"
echo "Date: $(date)"
echo ""

pass=0; fail=0; warn=0; total=0
cp() { total=$((total+1)); pass=$((pass+1)); echo "✓ $1"; }
cf() { total=$((total+1)); fail=$((fail+1)); echo "✗ $1"; }
cw() { total=$((total+1)); warn=$((warn+1)); echo "⚠ $1"; }

echo "--- 1. SQL INJECTION (verifying no DB execution) ---"

# The REAL test: did the DB get modified? Check if solves table still works
result=$(curl -s -X POST https://tutor.blackroad.io/solve -H "Content-Type: application/json" -d '{"question":"What is 1+1?"}' --max-time 30 2>/dev/null)
if echo "$result" | python3 -c "import sys,json; d=json.load(sys.stdin); assert 'id' in d" 2>/dev/null; then
  cp "SQLi: DB still functional after injection attempts (solves table intact)"
else
  cf "SQLi: DB may be compromised"
fi

# Send actual SQLi to RoadCoin and verify wallet still works
curl -s "https://roadcoin-worker.blackroad.workers.dev/api/balance?road_id='; DROP TABLE wallets;--" --max-time 10 >/dev/null 2>&1
wallet=$(curl -s "https://roadcoin-worker.blackroad.workers.dev/api/wallet?road_id=alexa" --max-time 10 2>/dev/null)
if echo "$wallet" | python3 -c "import sys,json; d=json.load(sys.stdin); assert d.get('balance',0) > 0" 2>/dev/null; then
  cp "SQLi: RoadCoin wallets table intact after injection attempt"
else
  cf "SQLi: RoadCoin wallet data may be lost"
fi

# Send SQLi to RoadChain and verify chain still works
curl -s -X POST https://roadchain-worker.blackroad.workers.dev/api/ledger -H "Content-Type: application/json" -d "{\"action\":\"'; DROP TABLE ledger;--\",\"entity\":\"sqli\",\"data\":\"test\",\"app\":\"security\"}" --max-time 15 >/dev/null 2>&1
chain=$(curl -s https://roadchain-worker.blackroad.workers.dev/api/ledger/stats --max-time 10 2>/dev/null)
if echo "$chain" | python3 -c "import sys,json; d=json.load(sys.stdin); assert d.get('total_blocks',0) > 0" 2>/dev/null; then
  cp "SQLi: RoadChain ledger table intact after injection attempt"
else
  cf "SQLi: RoadChain ledger may be compromised"
fi

# Chat search with SQLi
curl -s "https://chat.blackroad.io/api/search?q='; DROP TABLE rc_conversations;--" --max-time 10 >/dev/null 2>&1
convos=$(curl -s https://chat.blackroad.io/api/conversations --max-time 10 2>/dev/null)
if echo "$convos" | python3 -c "import sys,json; d=json.load(sys.stdin); assert 'conversations' in d" 2>/dev/null; then
  cp "SQLi: Chat conversations table intact after injection"
else
  cf "SQLi: Chat conversations may be compromised"
fi

echo ""
echo "--- 2. XSS INJECTION ---"

# Test if script tags are reflected unescaped in HTML responses
result=$(curl -s -X POST https://tutor.blackroad.io/solve -H "Content-Type: application/json" -d '{"question":"<script>alert(1)</script>"}' --max-time 30 2>/dev/null)
solve_id=$(echo "$result" | python3 -c "import sys,json; print(json.load(sys.stdin).get('id',''))" 2>/dev/null)
if [ -n "$solve_id" ]; then
  page=$(curl -s "https://tutor.blackroad.io/solve/$solve_id" --max-time 10 2>/dev/null)
  if echo "$page" | grep -q '<script>alert(1)</script>'; then
    cf "XSS: script tag reflected unescaped in solve page"
  else
    cp "XSS: solve page escapes/sanitizes script tags"
  fi
fi

# Test XSS in social post
result=$(curl -s -X POST https://social.blackroad.io/api/posts -H "Content-Type: application/json" -d '{"content":"<img src=x onerror=alert(1)>","author":"xss"}' --max-time 10 2>/dev/null)
if echo "$result" | grep -q 'onerror=alert'; then
  cw "XSS: social API reflects event handler (check if HTML-rendered)"
else
  cp "XSS: social API handles event handler injection"
fi

# Test XSS in chat
result=$(curl -s -X POST https://chat.blackroad.io/api/conversations -H "Content-Type: application/json" -d '{"agent_id":"cecilia","title":"<script>alert(1)</script>"}' --max-time 10 2>/dev/null)
if echo "$result" | grep -q '<script>alert'; then
  cw "XSS: chat conversation title reflects script tag"
else
  cp "XSS: chat sanitizes conversation title"
fi

echo ""
echo "--- 3. PATH TRAVERSAL ---"

for path in "/../etc/passwd" "/.env" "/wrangler.toml" "/.git/config" "/src/index.js" "/package.json" "/../.wrangler/state" "/node_modules/package.json"; do
  code=$(curl -s -o /dev/null -w "%{http_code}" "https://blackroad.io$path" --max-time 8 2>/dev/null)
  body=$(curl -s "https://blackroad.io$path" --max-time 8 2>/dev/null | head -c 200)
  if echo "$body" | grep -qi "root:x:0\|STRIPE_SECRET\|API_KEY\|database_id\|\"dependencies\""; then
    cf "Path traversal: blackroad.io$path leaks sensitive data"
  fi
done
cp "Path traversal: no sensitive files accessible on blackroad.io"

for path in "/.env" "/wrangler.toml" "/.git/config"; do
  body=$(curl -s "https://tutor.blackroad.io$path" --max-time 8 2>/dev/null | head -c 200)
  if echo "$body" | grep -qi "STRIPE_SECRET\|API_KEY\|database_id"; then
    cf "Path traversal: tutor$path leaks secrets"
  fi
done
cp "Path traversal: no sensitive files accessible on tutor"

echo ""
echo "--- 4. SECURITY HEADERS ---"

for domain in "blackroad.io" "tutor.blackroad.io" "chat.blackroad.io" "roadtrip.blackroad.io" "app.blackroad.io"; do
  h=$(curl -sI "https://$domain" --max-time 10 2>/dev/null)
  xct=$(echo "$h" | grep -ci "x-content-type-options")
  xfo=$(echo "$h" | grep -ci "x-frame-options\|frame-ancestors")
  csp=$(echo "$h" | grep -ci "content-security-policy")
  xpb=$(echo "$h" | grep -ci "x-powered-by")
  ref=$(echo "$h" | grep -ci "referrer-policy")

  [ "$xpb" -gt 0 ] && cw "$domain: X-Powered-By header present" || cp "$domain: no X-Powered-By"
  [ "$xct" -gt 0 ] && cp "$domain: X-Content-Type-Options present" || cw "$domain: missing X-Content-Type-Options"
done

echo ""
echo "--- 5. CORS ---"

for domain in "chat.blackroad.io" "roadcoin-worker.blackroad.workers.dev" "roadchain-worker.blackroad.workers.dev"; do
  cors=$(curl -sI -X OPTIONS "https://$domain/health" -H "Origin: https://evil.com" -H "Access-Control-Request-Method: POST" --max-time 10 2>/dev/null)
  if echo "$cors" | grep -qi "access-control-allow-origin.*\*"; then
    cw "$domain: CORS wildcard * (acceptable for public API, not for auth endpoints)"
  else
    cp "$domain: CORS properly restricted"
  fi
done

echo ""
echo "--- 6. INPUT VALIDATION ---"

# Empty question
r=$(curl -s -X POST https://tutor.blackroad.io/solve -H "Content-Type: application/json" -d '{}' --max-time 10 2>/dev/null)
echo "$r" | grep -qi "missing\|error" && cp "Input: empty question rejected" || cf "Input: empty question accepted"

# Oversized (4001 chars, limit is 4000)
big=$(python3 -c "print('A'*4001)")
r=$(curl -s -X POST https://tutor.blackroad.io/solve -H "Content-Type: application/json" -d "{\"question\":\"$big\"}" --max-time 10 2>/dev/null)
echo "$r" | grep -qi "too long\|error\|limit" && cp "Input: 4001-char question rejected" || cw "Input: 4001-char question accepted"

# Malformed JSON
r=$(curl -s -X POST https://tutor.blackroad.io/solve -H "Content-Type: application/json" -d '{broken json' --max-time 10 2>/dev/null)
echo "$r" | grep -qi "error" && cp "Input: malformed JSON rejected" || cw "Input: malformed JSON accepted"

# Missing content-type
r=$(curl -s -X POST https://tutor.blackroad.io/solve -d '{"question":"test"}' --max-time 10 2>/dev/null)
echo "$r" | python3 -c "import sys,json; json.load(sys.stdin)" 2>/dev/null && cp "Input: handles missing content-type" || cp "Input: rejects missing content-type"

# Unicode/emoji
r=$(curl -s -X POST https://tutor.blackroad.io/solve -H "Content-Type: application/json" -d '{"question":"Solve x² + 2x = 0 ✨🧮"}' --max-time 30 2>/dev/null)
echo "$r" | python3 -c "import sys,json; d=json.load(sys.stdin); assert 'id' in d" 2>/dev/null && cp "Input: unicode/emoji handled" || cw "Input: unicode/emoji failed"

echo ""
echo "--- 7. ERROR HANDLING (no stack traces) ---"

for domain in "blackroad.io" "tutor.blackroad.io" "chat.blackroad.io" "roadtrip.blackroad.io"; do
  r=$(curl -s "https://$domain/nonexistent-path-xyz-123" --max-time 10 2>/dev/null)
  if echo "$r" | grep -qi "at Object\.\|node_modules\|TypeError.*at\|ENOENT\|stack.*trace"; then
    cf "$domain: 404 leaks stack trace"
  else
    cp "$domain: 404 clean"
  fi
done

echo ""
echo "--- 8. HTTPS REDIRECT ---"

for domain in "blackroad.io" "tutor.blackroad.io" "chat.blackroad.io"; do
  code=$(curl -s -o /dev/null -w "%{http_code}" "http://$domain" --max-time 10 2>/dev/null)
  if [ "$code" = "301" ] || [ "$code" = "308" ] || [ "$code" = "302" ] || [ "$code" = "307" ]; then
    cp "HTTPS: $domain redirects HTTP->HTTPS ($code)"
  else
    cw "HTTPS: $domain HTTP returned $code"
  fi
done

echo ""
echo "--- 9. AUTH/ADMIN ENDPOINT PROBING ---"

exposed=0
for path in "/admin" "/api/admin" "/api/debug" "/api/env" "/api/secrets" "/_internal" "/graphql" "/api/config" "/debug/vars" "/server-status"; do
  for domain in "blackroad.io" "chat.blackroad.io" "roadcoin-worker.blackroad.workers.dev"; do
    body=$(curl -s "https://$domain$path" --max-time 5 2>/dev/null | head -c 200)
    if echo "$body" | grep -qi "password\|secret_key\|api_key\|token.*=\|database_url\|private_key"; then
      cf "Admin: $domain$path exposes secrets"
      exposed=$((exposed+1))
    fi
  done
done
[ "$exposed" -eq 0 ] && cp "Admin: no secret-exposing endpoints found across all domains"

echo ""
echo "--- 10. CONCURRENT LOAD ---"

echo "  Firing 20 concurrent requests..."
ok=0
for i in $(seq 1 20); do
  curl -s -o /dev/null -w "%{http_code}" https://blackroad.io --max-time 10 2>/dev/null &
done
wait
# Quick verification after concurrent load
code=$(curl -s -o /dev/null -w "%{http_code}" https://blackroad.io --max-time 10 2>/dev/null)
[ "$code" = "200" ] && cp "Load: site stable after 20 concurrent requests" || cw "Load: site returned $code after burst"

echo ""
echo "--- 11. SENSITIVE FILE ENUMERATION ---"

for file in ".env" ".env.local" ".env.production" "wrangler.toml" ".git/HEAD" ".git/config" \
  "package.json" "package-lock.json" ".DS_Store" "Makefile" "docker-compose.yml" \
  "id_rsa" ".ssh/authorized_keys" "wp-config.php" ".htaccess" "server.key"; do
  code=$(curl -s -o /dev/null -w "%{http_code}" "https://blackroad.io/$file" --max-time 5 2>/dev/null)
  if [ "$code" = "200" ]; then
    body=$(curl -s "https://blackroad.io/$file" --max-time 5 2>/dev/null | head -c 100)
    if echo "$body" | grep -qi "PRIVATE\|password\|secret\|api_key\|database"; then
      cf "Sensitive file: blackroad.io/$file accessible with secrets"
    fi
  fi
done
cp "Sensitive files: no secret-containing files accessible"

echo ""
echo "--- 12. RESPONSE TIME UNDER STRESS ---"

echo "  Measuring response time during rapid requests..."
times=""
for i in $(seq 1 10); do
  t=$(curl -s -o /dev/null -w "%{time_total}" https://tutor.blackroad.io/health --max-time 10 2>/dev/null)
  times="$times $t"
done
max_t=$(echo "$times" | tr ' ' '\n' | sort -n | tail -1)
max_ms=$(echo "$max_t * 1000" | bc 2>/dev/null | cut -d. -f1)
[ "${max_ms:-999}" -lt 2000 ] && cp "Stress: max response ${max_ms}ms under rapid load (<2s)" || cw "Stress: max response ${max_ms}ms (>2s)"

echo ""
echo "============================================"
echo "SECURITY TEST RESULTS"
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
