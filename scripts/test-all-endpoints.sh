#!/bin/bash
# Test ALL BlackRoad endpoints

echo "============================================"
echo "BLACKROAD OS — FULL ENDPOINT TEST SUITE"
echo "============================================"
echo "Date: $(date)"
echo ""

pass=0
fail=0
total=0

test_url() {
    local url="$1"
    local expected="$2"
    local desc="$3"
    total=$((total + 1))

    code=$(curl -s -o /tmp/br_test_body -w "%{http_code}" --max-time 10 "$url" 2>/dev/null)
    size=$(wc -c < /tmp/br_test_body 2>/dev/null | tr -d ' ')

    if [ "$code" = "$expected" ]; then
        echo "✓ $code ${size}B $desc"
        pass=$((pass + 1))
    else
        echo "✗ $code (expected $expected) $desc"
        fail=$((fail + 1))
    fi
}

test_json() {
    local url="$1"
    local key="$2"
    local desc="$3"
    total=$((total + 1))

    body=$(curl -s --max-time 10 "$url" 2>/dev/null)
    code=$(curl -s -o /dev/null -w "%{http_code}" --max-time 10 "$url" 2>/dev/null)

    if echo "$body" | python3 -c "import sys,json; d=json.load(sys.stdin); assert '$key' in str(d)" 2>/dev/null; then
        echo "✓ $code JSON:$key $desc"
        pass=$((pass + 1))
    else
        echo "✗ $code JSON:$key missing $desc"
        fail=$((fail + 1))
    fi
}

echo "--- HOMEPAGE & PAGES ---"
test_url "https://blackroad.io" "200" "blackroad.io homepage"
test_url "https://blackroad.io/pricing" "200" "blackroad.io/pricing"
test_url "https://blackroad.io/about" "200" "blackroad.io/about"
test_url "https://blackroad.io/roadmap" "200" "blackroad.io/roadmap"
test_url "https://blackroad.io/privacy" "200" "blackroad.io/privacy"
test_url "https://blackroad.io/legal" "200" "blackroad.io/legal"
test_url "https://blackroad.io/sitemap.xml" "200" "blackroad.io/sitemap.xml"
test_url "https://blackroad.io/robots.txt" "200" "blackroad.io/robots.txt"

echo ""
echo "--- BLACKROAD.IO API ---"
test_url "https://blackroad.io/health" "200" "blackroad.io health"
test_json "https://blackroad.io/api/stats" "agents" "blackroad.io stats API"
test_json "https://blackroad.io/api/products" "products" "blackroad.io products API"

echo ""
echo "--- TUTOR (PITSTOP) ---"
test_url "https://tutor.blackroad.io" "200" "tutor homepage"
test_url "https://tutor.blackroad.io/health" "200" "tutor health"
test_url "https://tutor.blackroad.io/sitemap.xml" "200" "tutor sitemap"
test_url "https://tutor.blackroad.io/robots.txt" "200" "tutor robots.txt"
test_url "https://tutor.blackroad.io/math" "200" "tutor /math"
test_url "https://tutor.blackroad.io/calculus" "200" "tutor /calculus"
test_url "https://tutor.blackroad.io/python" "200" "tutor /python"
test_url "https://tutor.blackroad.io/quadratic-equations" "200" "tutor /quadratic-equations"
test_url "https://tutor.blackroad.io/derivatives" "200" "tutor /derivatives"
test_url "https://tutor.blackroad.io/stoichiometry" "200" "tutor /stoichiometry"
test_url "https://tutor.blackroad.io/recursion" "200" "tutor /recursion"
test_url "https://tutor.blackroad.io/essay-writing" "200" "tutor /essay-writing"
test_url "https://tutor.blackroad.io/game-theory" "200" "tutor /game-theory"

echo ""
echo "--- CHAT ---"
test_url "https://chat.blackroad.io" "200" "chat homepage"
test_url "https://chat.blackroad.io/health" "200" "chat health"
test_json "https://chat.blackroad.io/api/rooms" "rooms" "chat rooms API"

echo ""
echo "--- SEARCH (ROADVIEW) ---"
test_url "https://search.blackroad.io" "200" "search homepage"
test_url "https://search.blackroad.io/health" "200" "search health"

echo ""
echo "--- SOCIAL (BACKROAD) ---"
test_url "https://social.blackroad.io" "200" "social homepage"
test_url "https://social.blackroad.io/health" "200" "social health"

echo ""
echo "--- AUTH ---"
test_url "https://auth.blackroad.io" "200" "auth homepage"
test_url "https://auth.blackroad.io/health" "200" "auth health"

echo ""
echo "--- ROADTRIP ---"
test_url "https://roadtrip.blackroad.io" "200" "roadtrip homepage"
test_url "https://roadtrip.blackroad.io/health" "200" "roadtrip health"
test_json "https://roadtrip.blackroad.io/api/agents" "agent" "roadtrip agents API"
test_json "https://roadtrip.blackroad.io/api/channels" "channel" "roadtrip channels API"

echo ""
echo "--- STATUS ---"
test_url "https://status.blackroad.io" "200" "status homepage"
test_url "https://status.blackroad.io/health" "200" "status health"

echo ""
echo "--- ROADCHAIN ---"
test_url "https://roadchain.io" "200" "roadchain homepage"
test_url "https://roadchain.io/health" "200" "roadchain health"

echo ""
echo "--- ROADCOIN ---"
test_url "https://roadcoin.io" "200" "roadcoin homepage"
test_url "https://roadcoin.io/health" "200" "roadcoin health"

echo ""
echo "--- CREATIVE APPS ---"
test_url "https://canvas.blackroad.io" "200" "canvas homepage"
test_url "https://cadence.blackroad.io" "200" "cadence homepage"
test_url "https://video.blackroad.io" "200" "video homepage"
test_url "https://game.blackroad.io" "200" "game homepage"
test_url "https://radio.blackroad.io" "200" "radio homepage"
test_url "https://live.blackroad.io" "200" "live homepage"

echo ""
echo "--- BUSINESS ---"
test_url "https://pay.blackroad.io" "200" "pay homepage"
test_url "https://hq.blackroad.io" "200" "hq homepage"
test_url "https://roadcode.blackroad.io" "200" "roadcode homepage"

echo ""
echo "--- APP (BLACKBOARD/DESKTOP) ---"
test_url "https://app.blackroad.io" "200" "app desktop OS"

echo ""
echo "--- OTHER DOMAINS ---"
test_url "https://blackboxprogramming.io" "200" "dev profile"

echo ""
echo "--- TUTOR SOLVE API (POST) ---"
solve_result=$(curl -s -X POST https://tutor.blackroad.io/solve \
  -H "Content-Type: application/json" \
  -d '{"question":"What is 2+2?"}' --max-time 30 2>/dev/null)
total=$((total + 1))
if echo "$solve_result" | python3 -c "import sys,json; d=json.load(sys.stdin); assert 'id' in d or 'answer' in d or 'preview' in d" 2>/dev/null; then
    echo "✓ POST tutor/solve returns valid response"
    pass=$((pass + 1))
else
    echo "✗ POST tutor/solve: $solve_result"
    fail=$((fail + 1))
fi

echo ""
echo "--- ROADTRIP CHAT API (POST) ---"
chat_result=$(curl -s -X POST https://roadtrip.blackroad.io/api/chat \
  -H "Content-Type: application/json" \
  -d '{"agent":"road","message":"ping","channel":"general"}' --max-time 15 2>/dev/null)
total=$((total + 1))
if echo "$chat_result" | python3 -c "import sys,json; json.load(sys.stdin)" 2>/dev/null; then
    echo "✓ POST roadtrip/chat returns JSON"
    pass=$((pass + 1))
else
    echo "✗ POST roadtrip/chat: $(echo "$chat_result" | head -c 100)"
    fail=$((fail + 1))
fi

echo ""
echo "============================================"
echo "TEST RESULTS: $pass passed, $fail failed, $total total"
echo "Pass rate: $(echo "scale=1; $pass * 100 / $total" | bc)%"
echo "============================================"
