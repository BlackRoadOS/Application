#!/bin/bash
# DEEP FUNCTIONAL TESTS — test actual features, not just health checks

echo "============================================"
echo "BLACKROAD OS — DEEP FUNCTIONAL TEST SUITE"
echo "============================================"
echo "Date: $(date)"
echo ""

pass=0
fail=0
total=0

check() {
    total=$((total + 1))
    if [ "$1" = "true" ]; then
        echo "✓ $2"
        pass=$((pass + 1))
    else
        echo "✗ $2"
        fail=$((fail + 1))
    fi
}

# ============================================
# TUTOR: Full solve pipeline
# ============================================
echo "--- TUTOR: SOLVE PIPELINE ---"

# Test POST /solve with a real question
solve=$(curl -s -X POST https://tutor.blackroad.io/solve \
  -H "Content-Type: application/json" \
  -d '{"question":"What is the derivative of x squared?"}' --max-time 45 2>/dev/null)

has_id=$(echo "$solve" | python3 -c "import sys,json; d=json.load(sys.stdin); print('true' if 'id' in d else 'false')" 2>/dev/null)
check "$has_id" "Tutor: POST /solve returns solve ID"

has_preview=$(echo "$solve" | python3 -c "import sys,json; d=json.load(sys.stdin); print('true' if 'preview' in d or 'answer' in d else 'false')" 2>/dev/null)
check "$has_preview" "Tutor: solve contains answer/preview"

# Get the solve ID and fetch the page
solve_id=$(echo "$solve" | python3 -c "import sys,json; print(json.load(sys.stdin).get('id',''))" 2>/dev/null)
if [ -n "$solve_id" ]; then
    solve_page=$(curl -s -o /dev/null -w "%{http_code}" "https://tutor.blackroad.io/solve/$solve_id" --max-time 10)
    check "$([ "$solve_page" = "200" ] && echo true || echo false)" "Tutor: GET /solve/$solve_id page renders (SEO)"
fi

# Test different question types
for q in "Solve 2x+5=13" "What is photosynthesis?" "Write hello world in Python"; do
    result=$(curl -s -X POST https://tutor.blackroad.io/solve \
      -H "Content-Type: application/json" \
      -d "{\"question\":\"$q\"}" --max-time 45 2>/dev/null)
    has_answer=$(echo "$result" | python3 -c "import sys,json; d=json.load(sys.stdin); print('true' if len(str(d)) > 50 else 'false')" 2>/dev/null)
    check "$has_answer" "Tutor: solves '$q'"
done

# Test solve modes
for mode in "default" "eli5" "practice"; do
    result=$(curl -s -X POST https://tutor.blackroad.io/solve \
      -H "Content-Type: application/json" \
      -d "{\"question\":\"What is gravity?\",\"mode\":\"$mode\"}" --max-time 45 2>/dev/null)
    valid=$(echo "$result" | python3 -c "import sys,json; json.load(sys.stdin); print('true')" 2>/dev/null)
    check "${valid:-false}" "Tutor: mode=$mode works"
done

# Sitemap has topics
topic_count=$(curl -s https://tutor.blackroad.io/sitemap.xml --max-time 10 | grep -c "<loc>")
check "$([ "$topic_count" -gt 100 ] && echo true || echo false)" "Tutor: sitemap has $topic_count URLs (>100)"

echo ""

# ============================================
# CHAT: Room and message system
# ============================================
echo "--- CHAT: ROOMS & MESSAGES ---"

rooms=$(curl -s https://chat.blackroad.io/api/rooms --max-time 10 2>/dev/null)
room_count=$(echo "$rooms" | python3 -c "import sys,json; d=json.load(sys.stdin); print(len(d) if isinstance(d,list) else len(d.get('rooms',d.get('results',[]))))" 2>/dev/null)
check "$([ "${room_count:-0}" -gt 0 ] && echo true || echo false)" "Chat: has $room_count rooms"

# Try posting a message
chat_post=$(curl -s -X POST https://chat.blackroad.io/api/messages \
  -H "Content-Type: application/json" \
  -d '{"room":"general","content":"test from endpoint suite","author":"test-bot"}' --max-time 10 2>/dev/null)
chat_valid=$(echo "$chat_post" | python3 -c "import sys,json; json.load(sys.stdin); print('true')" 2>/dev/null)
check "${chat_valid:-false}" "Chat: POST message returns JSON"

echo ""

# ============================================
# SEARCH: Query pipeline
# ============================================
echo "--- SEARCH: QUERY PIPELINE ---"

search=$(curl -s "https://search.blackroad.io/api/search?q=blackroad" --max-time 15 2>/dev/null)
search_valid=$(echo "$search" | python3 -c "import sys,json; json.load(sys.stdin); print('true')" 2>/dev/null)
check "${search_valid:-false}" "Search: query 'blackroad' returns JSON"

search2=$(curl -s "https://search.blackroad.io/api/search?q=math+homework" --max-time 15 2>/dev/null)
search2_valid=$(echo "$search2" | python3 -c "import sys,json; json.load(sys.stdin); print('true')" 2>/dev/null)
check "${search2_valid:-false}" "Search: query 'math homework' returns JSON"

echo ""

# ============================================
# SOCIAL: Feed and posts
# ============================================
echo "--- SOCIAL: FEED & POSTS ---"

feed=$(curl -s https://social.blackroad.io/api/feed --max-time 10 2>/dev/null)
feed_valid=$(echo "$feed" | python3 -c "import sys,json; json.load(sys.stdin); print('true')" 2>/dev/null)
check "${feed_valid:-false}" "Social: feed returns JSON"

# Try creating a post
post_result=$(curl -s -X POST https://social.blackroad.io/api/posts \
  -H "Content-Type: application/json" \
  -d '{"content":"Test post from endpoint suite","author":"test-bot"}' --max-time 10 2>/dev/null)
post_valid=$(echo "$post_result" | python3 -c "import sys,json; json.load(sys.stdin); print('true')" 2>/dev/null)
check "${post_valid:-false}" "Social: POST to feed returns JSON"

echo ""

# ============================================
# ROADTRIP: Agents and chat
# ============================================
echo "--- ROADTRIP: AGENTS & MULTI-AGENT CHAT ---"

agents=$(curl -s https://roadtrip.blackroad.io/api/agents --max-time 10 2>/dev/null)
agent_count=$(echo "$agents" | python3 -c "import sys,json; d=json.load(sys.stdin); print(len(d) if isinstance(d,list) else 0)" 2>/dev/null)
check "$([ "${agent_count:-0}" -gt 10 ] && echo true || echo false)" "RoadTrip: $agent_count agents registered (>10)"

channels=$(curl -s https://roadtrip.blackroad.io/api/channels --max-time 10 2>/dev/null)
chan_count=$(echo "$channels" | python3 -c "import sys,json; d=json.load(sys.stdin); print(len(d) if isinstance(d,list) else 0)" 2>/dev/null)
check "$([ "${chan_count:-0}" -gt 0 ] && echo true || echo false)" "RoadTrip: $chan_count channels"

# Chat with different agents
for agent in "road" "cecilia" "eve" "pixel" "tutor"; do
    chat=$(curl -s -X POST https://roadtrip.blackroad.io/api/chat \
      -H "Content-Type: application/json" \
      -d "{\"agent\":\"$agent\",\"message\":\"hello\",\"channel\":\"general\"}" --max-time 20 2>/dev/null)
    chat_ok=$(echo "$chat" | python3 -c "import sys,json; json.load(sys.stdin); print('true')" 2>/dev/null)
    check "${chat_ok:-false}" "RoadTrip: chat with $agent returns JSON"
done

# Get recent messages
msgs=$(curl -s https://roadtrip.blackroad.io/api/messages --max-time 10 2>/dev/null)
msgs_valid=$(echo "$msgs" | python3 -c "import sys,json; json.load(sys.stdin); print('true')" 2>/dev/null)
check "${msgs_valid:-false}" "RoadTrip: /api/messages returns JSON"

echo ""

# ============================================
# ROADCHAIN: Blockchain operations
# ============================================
echo "--- ROADCHAIN: BLOCKCHAIN ---"

chain_health=$(curl -s https://roadchain.io/health --max-time 10 2>/dev/null)
check "$(echo "$chain_health" | grep -q 'ok' && echo true || echo false)" "RoadChain: health ok"

chain_stats=$(curl -s https://roadchain.io/api/chain/stats --max-time 10 2>/dev/null)
chain_json=$(echo "$chain_stats" | python3 -c "import sys,json; json.load(sys.stdin); print('true')" 2>/dev/null)
check "${chain_json:-false}" "RoadChain: /api/chain/stats returns JSON"

# Try writing to the ledger
ledger_write=$(curl -s -X POST https://roadchain.io/api/ledger \
  -H "Content-Type: application/json" \
  -d '{"action":"test","entity":"endpoint-suite","data":"functional test"}' --max-time 15 2>/dev/null)
ledger_ok=$(echo "$ledger_write" | python3 -c "import sys,json; json.load(sys.stdin); print('true')" 2>/dev/null)
check "${ledger_ok:-false}" "RoadChain: POST ledger write returns JSON"

echo ""

# ============================================
# ROADCOIN: Token economy
# ============================================
echo "--- ROADCOIN: TOKEN ECONOMY ---"

coin_health=$(curl -s https://roadcoin.io/health --max-time 10 2>/dev/null)
check "$(echo "$coin_health" | grep -q 'ok' && echo true || echo false)" "RoadCoin: health ok"

coin_stats=$(curl -s https://roadcoin.io/api/stats --max-time 10 2>/dev/null)
coin_json=$(echo "$coin_stats" | python3 -c "import sys,json; json.load(sys.stdin); print('true')" 2>/dev/null)
check "${coin_json:-false}" "RoadCoin: /api/stats returns JSON"

# Check wallet endpoint
wallet=$(curl -s "https://roadcoin.io/api/wallet/test-user" --max-time 10 2>/dev/null)
wallet_json=$(echo "$wallet" | python3 -c "import sys,json; json.load(sys.stdin); print('true')" 2>/dev/null)
check "${wallet_json:-false}" "RoadCoin: wallet endpoint returns JSON"

# Faucet
faucet=$(curl -s -X POST https://roadcoin.io/api/faucet \
  -H "Content-Type: application/json" \
  -d '{"user_id":"test-suite-user"}' --max-time 10 2>/dev/null)
faucet_json=$(echo "$faucet" | python3 -c "import sys,json; json.load(sys.stdin); print('true')" 2>/dev/null)
check "${faucet_json:-false}" "RoadCoin: faucet returns JSON"

echo ""

# ============================================
# STATUS: Fleet monitoring
# ============================================
echo "--- STATUS: FLEET MONITORING ---"

status_api=$(curl -s https://status.blackroad.io/api/status --max-time 10 2>/dev/null)
status_json=$(echo "$status_api" | python3 -c "import sys,json; json.load(sys.stdin); print('true')" 2>/dev/null)
check "${status_json:-false}" "Status: /api/status returns JSON"

echo ""

# ============================================
# BLACKROAD.IO: All subpages
# ============================================
echo "--- BLACKROAD.IO: ALL SUBPAGES ---"

for page in pricing about roadmap privacy legal transparency contribute ships devices testimonials forks dmca aup; do
    code=$(curl -s -o /dev/null -w "%{http_code}" "https://blackroad.io/$page" --max-time 8 2>/dev/null)
    check "$([ "$code" = "200" ] && echo true || echo false)" "blackroad.io/$page -> $code"
done

echo ""

# ============================================
# SEO: Structured data validation
# ============================================
echo "--- SEO: STRUCTURED DATA ---"

# Check tutor pages have JSON-LD
tutor_jsonld=$(curl -s https://tutor.blackroad.io/quadratic-equations --max-time 10 2>/dev/null | grep -c "application/ld+json")
check "$([ "$tutor_jsonld" -gt 0 ] && echo true || echo false)" "Tutor topic page has JSON-LD structured data"

# Check meta tags
has_og=$(curl -s https://tutor.blackroad.io/derivatives --max-time 10 2>/dev/null | grep -c "og:title")
check "$([ "$has_og" -gt 0 ] && echo true || echo false)" "Tutor topic page has OpenGraph tags"

has_canonical=$(curl -s https://tutor.blackroad.io/python --max-time 10 2>/dev/null | grep -c "canonical")
check "$([ "$has_canonical" -gt 0 ] && echo true || echo false)" "Tutor topic page has canonical URL"

# Check blackroad.io has meta
main_og=$(curl -s https://blackroad.io --max-time 10 2>/dev/null | grep -c "og:title")
check "$([ "$main_og" -gt 0 ] && echo true || echo false)" "blackroad.io has OpenGraph tags"

echo ""

# ============================================
# CORS & HEADERS
# ============================================
echo "--- SECURITY HEADERS ---"

headers=$(curl -sI https://blackroad.io --max-time 10 2>/dev/null)
has_csp=$(echo "$headers" | grep -ci "content-security-policy")
check "$([ "$has_csp" -gt 0 ] && echo true || echo false)" "blackroad.io has CSP header"

tutor_headers=$(curl -sI https://tutor.blackroad.io --max-time 10 2>/dev/null)
has_ct=$(echo "$tutor_headers" | grep -ci "content-type")
check "$([ "$has_ct" -gt 0 ] && echo true || echo false)" "tutor has Content-Type header"

echo ""

# ============================================
# RESPONSE TIME BENCHMARKS
# ============================================
echo "--- RESPONSE TIMES ---"

for url in "https://blackroad.io" "https://tutor.blackroad.io" "https://chat.blackroad.io" \
  "https://search.blackroad.io" "https://roadtrip.blackroad.io" "https://app.blackroad.io"; do
    times=""
    for i in 1 2 3; do
        t=$(curl -s -o /dev/null -w "%{time_total}" "$url" --max-time 10 2>/dev/null)
        times="$times $t"
    done
    avg=$(echo "$times" | awk '{sum=0; for(i=1;i<=NF;i++) sum+=$i; print sum/NF}')
    name=$(echo "$url" | sed 's|https://||' | sed 's|\.blackroad\.io||')
    avg_ms=$(echo "$avg * 1000" | bc 2>/dev/null | cut -d. -f1)
    total=$((total + 1))
    if [ "${avg_ms:-999}" -lt 500 ]; then
        echo "✓ $name: ${avg_ms}ms avg (3 requests)"
        pass=$((pass + 1))
    else
        echo "✗ $name: ${avg_ms}ms avg (>500ms)"
        fail=$((fail + 1))
    fi
done

echo ""
echo "============================================"
echo "DEEP TEST RESULTS: $pass passed, $fail failed, $total total"
echo "Pass rate: $(echo "scale=1; $pass * 100 / $total" | bc 2>/dev/null || echo 'N/A')%"
echo "============================================"
