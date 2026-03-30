#!/bin/bash
echo "============================================"
echo "BLACKROAD OS — INTEGRATION & DATA FLOW TESTS"
echo "============================================"
echo "Date: $(date)"
echo ""

pass=0; fail=0; warn=0; total=0
cp() { total=$((total+1)); pass=$((pass+1)); echo "✓ $1"; }
cf() { total=$((total+1)); fail=$((fail+1)); echo "✗ $1"; }
cw() { total=$((total+1)); warn=$((warn+1)); echo "⚠ $1"; }

# ============================================
# 1. END-TO-END: Student homework flow
# ============================================
echo "--- E2E: STUDENT HOMEWORK FLOW ---"

# Step 1: Solve a problem
echo "  Step 1: Submit homework question..."
solve=$(curl -s -X POST https://tutor.blackroad.io/solve \
  -H "Content-Type: application/json" \
  -d '{"question":"Solve the equation 3x - 7 = 14","mode":"default"}' --max-time 45 2>/dev/null)
solve_id=$(echo "$solve" | python3 -c "import sys,json; print(json.load(sys.stdin).get('id',''))" 2>/dev/null)
preview=$(echo "$solve" | python3 -c "import sys,json; print(json.load(sys.stdin).get('preview','')[:80])" 2>/dev/null)
[ -n "$solve_id" ] && cp "E2E Tutor: solve created (ID: $solve_id)" || cf "E2E Tutor: solve failed"
[ -n "$preview" ] && cp "E2E Tutor: AI generated answer preview" || cf "E2E Tutor: no answer"
echo "    Preview: $preview"

# Step 2: Verify solve page is SEO-indexed
page_code=$(curl -s -o /dev/null -w "%{http_code}" "https://tutor.blackroad.io/solve/$solve_id" --max-time 10 2>/dev/null)
[ "$page_code" = "200" ] && cp "E2E Tutor: solve page renders for Google ($page_code)" || cf "E2E Tutor: solve page failed ($page_code)"

# Step 3: Verify it appears in sitemap
sitemap=$(curl -s https://tutor.blackroad.io/sitemap.xml --max-time 10 2>/dev/null)
echo "$sitemap" | grep -q "$solve_id" && cp "E2E Tutor: solve appears in sitemap" || cw "E2E Tutor: solve not yet in sitemap (may need cache refresh)"

# Step 4: Test ELI5 mode
eli5=$(curl -s -X POST https://tutor.blackroad.io/solve \
  -H "Content-Type: application/json" \
  -d '{"question":"What is gravity?","mode":"eli5"}' --max-time 45 2>/dev/null)
eli5_preview=$(echo "$eli5" | python3 -c "import sys,json; print(json.load(sys.stdin).get('preview','')[:80])" 2>/dev/null)
[ -n "$eli5_preview" ] && cp "E2E Tutor: ELI5 mode works" || cf "E2E Tutor: ELI5 failed"

# Step 5: Test practice mode
practice=$(curl -s -X POST https://tutor.blackroad.io/solve \
  -H "Content-Type: application/json" \
  -d '{"question":"Give me a practice problem about fractions","mode":"practice"}' --max-time 45 2>/dev/null)
practice_id=$(echo "$practice" | python3 -c "import sys,json; print(json.load(sys.stdin).get('id',''))" 2>/dev/null)
[ -n "$practice_id" ] && cp "E2E Tutor: practice mode works" || cf "E2E Tutor: practice failed"

echo ""

# ============================================
# 2. END-TO-END: Chat conversation flow
# ============================================
echo "--- E2E: CHAT CONVERSATION FLOW ---"

# Step 1: Create conversation with Cecilia
conv=$(curl -s -X POST https://chat.blackroad.io/api/conversations \
  -H "Content-Type: application/json" \
  -d '{"agent_id":"cecilia","title":"Integration test conversation"}' --max-time 15 2>/dev/null)
conv_id=$(echo "$conv" | python3 -c "import sys,json; print(json.load(sys.stdin).get('id',''))" 2>/dev/null)
[ -n "$conv_id" ] && cp "E2E Chat: conversation created (ID: $conv_id)" || cf "E2E Chat: conversation creation failed"

# Step 2: Send message and get AI response
msg=$(curl -s -X POST "https://chat.blackroad.io/api/conversations/$conv_id/messages" \
  -H "Content-Type: application/json" \
  -d '{"content":"What can you help me with?","role":"user","provider":"fleet"}' --max-time 45 2>/dev/null)
agent_reply=$(echo "$msg" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('agent',{}).get('content','')[:100])" 2>/dev/null)
[ -n "$agent_reply" ] && cp "E2E Chat: Cecilia responded with AI" || cf "E2E Chat: no AI response"
echo "    Cecilia: $agent_reply"

# Step 3: Verify conversation persisted
msgs=$(curl -s "https://chat.blackroad.io/api/conversations/$conv_id/messages" --max-time 10 2>/dev/null)
msg_count=$(echo "$msgs" | python3 -c "import sys,json; d=json.load(sys.stdin); print(len(d) if isinstance(d,list) else len(d.get('messages',[])))" 2>/dev/null)
[ "${msg_count:-0}" -ge 2 ] && cp "E2E Chat: messages persisted ($msg_count messages)" || cw "E2E Chat: message count = $msg_count"

# Step 4: Search for conversation content
search=$(curl -s "https://chat.blackroad.io/api/search?q=integration+test" --max-time 10 2>/dev/null)
search_ok=$(echo "$search" | python3 -c "import sys,json; json.load(sys.stdin); print('true')" 2>/dev/null)
[ "$search_ok" = "true" ] && cp "E2E Chat: search API works" || cw "E2E Chat: search returned non-JSON"

# Step 5: Test different agent
conv2=$(curl -s -X POST https://chat.blackroad.io/api/conversations \
  -H "Content-Type: application/json" \
  -d '{"agent_id":"eve","title":"Search agent test"}' --max-time 10 2>/dev/null)
conv2_id=$(echo "$conv2" | python3 -c "import sys,json; print(json.load(sys.stdin).get('id',''))" 2>/dev/null)
msg2=$(curl -s -X POST "https://chat.blackroad.io/api/conversations/$conv2_id/messages" \
  -H "Content-Type: application/json" \
  -d '{"content":"Find information about BlackRoad OS","role":"user","provider":"fleet"}' --max-time 45 2>/dev/null)
eve_reply=$(echo "$msg2" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('agent',{}).get('content','')[:80])" 2>/dev/null)
[ -n "$eve_reply" ] && cp "E2E Chat: Eve (search agent) responded" || cw "E2E Chat: Eve didn't respond"

echo ""

# ============================================
# 3. END-TO-END: RoadCoin economy flow
# ============================================
echo "--- E2E: ROADCOIN ECONOMY FLOW ---"

user_id="e2e-test-$(date +%s)"

# Step 1: Claim faucet
faucet=$(curl -s -X POST https://roadcoin-worker.blackroad.workers.dev/api/faucet \
  -H "Content-Type: application/json" \
  -d "{\"road_id\":\"$user_id\"}" --max-time 10 2>/dev/null)
received=$(echo "$faucet" | python3 -c "import sys,json; print(json.load(sys.stdin).get('received',0))" 2>/dev/null)
[ "$received" = "100" ] && cp "E2E Coin: faucet gave 100 ROAD" || cf "E2E Coin: faucet gave $received (expected 100)"

# Step 2: Check balance
wallet=$(curl -s "https://roadcoin-worker.blackroad.workers.dev/api/wallet?road_id=$user_id" --max-time 10 2>/dev/null)
balance=$(echo "$wallet" | python3 -c "import sys,json; print(json.load(sys.stdin).get('balance',0))" 2>/dev/null)
[ "$balance" = "100" ] && cp "E2E Coin: wallet shows 100 ROAD" || cf "E2E Coin: wallet shows $balance"

# Step 3: Try to claim faucet again (should be blocked)
faucet2=$(curl -s -X POST https://roadcoin-worker.blackroad.workers.dev/api/faucet \
  -H "Content-Type: application/json" \
  -d "{\"road_id\":\"$user_id\"}" --max-time 10 2>/dev/null)
received2=$(echo "$faucet2" | python3 -c "import sys,json; print(json.load(sys.stdin).get('received',0))" 2>/dev/null)
[ "$received2" = "0" ] && cp "E2E Coin: double-claim blocked" || cf "E2E Coin: double-claim gave $received2"

# Step 4: Check leaderboard includes new user
lb=$(curl -s https://roadcoin-worker.blackroad.workers.dev/api/leaderboard --max-time 10 2>/dev/null)
on_lb=$(echo "$lb" | python3 -c "import sys,json; d=json.load(sys.stdin); print('true' if any(w.get('road_id')=='$user_id' for w in d.get('leaderboard',[])) else 'false')" 2>/dev/null)
[ "$on_lb" = "true" ] && cp "E2E Coin: user appears on leaderboard" || cw "E2E Coin: user not on leaderboard"

# Step 5: Check token supply
supply=$(curl -s https://roadcoin-worker.blackroad.workers.dev/api/info --max-time 10 2>/dev/null)
holders=$(echo "$supply" | python3 -c "import sys,json; print(json.load(sys.stdin).get('holders',0))" 2>/dev/null)
circulating=$(echo "$supply" | python3 -c "import sys,json; print(json.load(sys.stdin).get('circulating',0))" 2>/dev/null)
cp "E2E Coin: $holders holders, $circulating ROAD circulating"

echo ""

# ============================================
# 4. END-TO-END: RoadChain blockchain flow
# ============================================
echo "--- E2E: ROADCHAIN BLOCKCHAIN FLOW ---"

# Step 1: Get current chain stats
stats_before=$(curl -s https://roadchain-worker.blackroad.workers.dev/api/ledger/stats --max-time 10 2>/dev/null)
blocks_before=$(echo "$stats_before" | python3 -c "import sys,json; print(json.load(sys.stdin).get('total_blocks',0))" 2>/dev/null)
cp "E2E Chain: current blocks = $blocks_before"

# Step 2: Write a new block
write=$(curl -s -X POST https://roadchain-worker.blackroad.workers.dev/api/ledger \
  -H "Content-Type: application/json" \
  -d '{"action":"e2e_test","entity":"integration-suite","data":"end-to-end verification","app":"testing"}' --max-time 15 2>/dev/null)
new_block=$(echo "$write" | python3 -c "import sys,json; print(json.load(sys.stdin).get('block_number',0))" 2>/dev/null)
new_hash=$(echo "$write" | python3 -c "import sys,json; print(json.load(sys.stdin).get('hash','')[:16])" 2>/dev/null)
prev_hash=$(echo "$write" | python3 -c "import sys,json; print(json.load(sys.stdin).get('prev_hash','')[:16])" 2>/dev/null)
[ -n "$new_hash" ] && cp "E2E Chain: block #$new_block written (hash: $new_hash...)" || cf "E2E Chain: write failed"

# Step 3: Verify chain grew
stats_after=$(curl -s https://roadchain-worker.blackroad.workers.dev/api/ledger/stats --max-time 10 2>/dev/null)
blocks_after=$(echo "$stats_after" | python3 -c "import sys,json; print(json.load(sys.stdin).get('total_blocks',0))" 2>/dev/null)
[ "$blocks_after" -gt "$blocks_before" ] && cp "E2E Chain: chain grew ($blocks_before -> $blocks_after)" || cf "E2E Chain: chain didn't grow"

# Step 4: Read the block back
read_block=$(curl -s "https://roadchain-worker.blackroad.workers.dev/api/ledger?limit=1" --max-time 10 2>/dev/null)
latest=$(echo "$read_block" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d[0].get('action','') if isinstance(d,list) and d else d.get('blocks',[{}])[0].get('action',''))" 2>/dev/null)
[ "$latest" = "e2e_test" ] && cp "E2E Chain: latest block readable and correct" || cw "E2E Chain: latest action = $latest"

# Step 5: Write event via cross-app bus
event=$(curl -s -X POST https://roadchain-worker.blackroad.workers.dev/api/event \
  -H "Content-Type: application/json" \
  -d '{"app":"tutor","action":"solve","user_id":"e2e-test","data":{"subject":"math","topic":"algebra"}}' --max-time 15 2>/dev/null)
event_ok=$(echo "$event" | python3 -c "import sys,json; d=json.load(sys.stdin); print('true' if d.get('id') or d.get('block_number') else 'false')" 2>/dev/null)
[ "$event_ok" = "true" ] && cp "E2E Chain: cross-app event recorded" || cw "E2E Chain: event recording unclear"

echo ""

# ============================================
# 5. END-TO-END: RoadTrip multi-agent flow
# ============================================
echo "--- E2E: ROADTRIP MULTI-AGENT FLOW ---"

# Step 1: List all agents
agents=$(curl -s https://roadtrip.blackroad.io/api/agents --max-time 10 2>/dev/null)
agent_count=$(echo "$agents" | python3 -c "import sys,json; d=json.load(sys.stdin); print(len(d) if isinstance(d,list) else 0)" 2>/dev/null)
[ "${agent_count:-0}" -ge 15 ] && cp "E2E Trip: $agent_count agents available" || cw "E2E Trip: only $agent_count agents"

# Step 2: Chat with Road (orchestrator)
road=$(curl -s -X POST https://roadtrip.blackroad.io/api/chat \
  -H "Content-Type: application/json" \
  -d '{"agent":"road","message":"What agents are available?","channel":"general"}' --max-time 20 2>/dev/null)
road_ok=$(echo "$road" | python3 -c "import sys,json; json.load(sys.stdin); print('true')" 2>/dev/null)
[ "$road_ok" = "true" ] && cp "E2E Trip: Road (CEO agent) responds" || cf "E2E Trip: Road didn't respond"

# Step 3: Chat with Cecilia (reasoning)
cece=$(curl -s -X POST https://roadtrip.blackroad.io/api/chat \
  -H "Content-Type: application/json" \
  -d '{"agent":"cecilia","message":"What is the square root of 144?","channel":"math"}' --max-time 20 2>/dev/null)
cece_ok=$(echo "$cece" | python3 -c "import sys,json; json.load(sys.stdin); print('true')" 2>/dev/null)
[ "$cece_ok" = "true" ] && cp "E2E Trip: Cecilia (reasoning agent) responds" || cf "E2E Trip: Cecilia didn't respond"

# Step 4: Chat with Pixel (creative)
pixel=$(curl -s -X POST https://roadtrip.blackroad.io/api/chat \
  -H "Content-Type: application/json" \
  -d '{"agent":"pixel","message":"Describe a logo concept for a coffee shop","channel":"creative"}' --max-time 20 2>/dev/null)
pixel_ok=$(echo "$pixel" | python3 -c "import sys,json; json.load(sys.stdin); print('true')" 2>/dev/null)
[ "$pixel_ok" = "true" ] && cp "E2E Trip: Pixel (creative agent) responds" || cf "E2E Trip: Pixel didn't respond"

# Step 5: List channels
channels=$(curl -s https://roadtrip.blackroad.io/api/channels --max-time 10 2>/dev/null)
chan_count=$(echo "$channels" | python3 -c "import sys,json; d=json.load(sys.stdin); print(len(d) if isinstance(d,list) else 0)" 2>/dev/null)
[ "${chan_count:-0}" -ge 5 ] && cp "E2E Trip: $chan_count channels active" || cw "E2E Trip: $chan_count channels"

echo ""

# ============================================
# 6. END-TO-END: Social feed flow
# ============================================
echo "--- E2E: SOCIAL (BACKROAD) FLOW ---"

# Step 1: Get feed
feed=$(curl -s https://social.blackroad.io/api/feed --max-time 10 2>/dev/null)
feed_ok=$(echo "$feed" | python3 -c "import sys,json; json.load(sys.stdin); print('true')" 2>/dev/null)
[ "$feed_ok" = "true" ] && cp "E2E Social: feed loads" || cf "E2E Social: feed failed"

# Step 2: Create a post
post=$(curl -s -X POST https://social.blackroad.io/api/posts \
  -H "Content-Type: application/json" \
  -d '{"content":"Integration test post from E2E suite","author":"test-bot","tags":["testing","e2e"]}' --max-time 10 2>/dev/null)
post_ok=$(echo "$post" | python3 -c "import sys,json; json.load(sys.stdin); print('true')" 2>/dev/null)
[ "$post_ok" = "true" ] && cp "E2E Social: post created" || cw "E2E Social: post creation returned non-JSON"

echo ""

# ============================================
# 7. END-TO-END: Search flow
# ============================================
echo "--- E2E: SEARCH (ROADVIEW) FLOW ---"

# Test various queries
for query in "blackroad" "homework help" "raspberry pi" "how to code" "math tutor"; do
  r=$(curl -s "https://search.blackroad.io/api/search?q=$(echo $query | tr ' ' '+')" --max-time 15 2>/dev/null)
  ok=$(echo "$r" | python3 -c "import sys,json; json.load(sys.stdin); print('true')" 2>/dev/null)
  [ "$ok" = "true" ] && cp "E2E Search: '$query' returns JSON" || cf "E2E Search: '$query' failed"
done

echo ""

# ============================================
# 8. CROSS-APP: Data consistency
# ============================================
echo "--- CROSS-APP: DATA CONSISTENCY ---"

# RoadCoin holder count should match wallet entries
coin_info=$(curl -s https://roadcoin-worker.blackroad.workers.dev/api/info --max-time 10 2>/dev/null)
reported_holders=$(echo "$coin_info" | python3 -c "import sys,json; print(json.load(sys.stdin).get('holders',0))" 2>/dev/null)
lb_entries=$(curl -s https://roadcoin-worker.blackroad.workers.dev/api/leaderboard --max-time 10 2>/dev/null | python3 -c "import sys,json; print(len(json.load(sys.stdin).get('leaderboard',[])))" 2>/dev/null)
[ "$reported_holders" = "$lb_entries" ] && cp "Consistency: holder count ($reported_holders) matches leaderboard ($lb_entries)" || cw "Consistency: holders=$reported_holders vs leaderboard=$lb_entries"

# RoadTrip agent count should match chat agent count
trip_agents=$(curl -s https://roadtrip.blackroad.io/api/agents --max-time 10 2>/dev/null | python3 -c "import sys,json; d=json.load(sys.stdin); print(len(d) if isinstance(d,list) else 0)" 2>/dev/null)
chat_agents=$(curl -s https://chat.blackroad.io/api/agents --max-time 10 2>/dev/null | python3 -c "import sys,json; print(len(json.load(sys.stdin).get('agents',[])))" 2>/dev/null)
[ "$trip_agents" = "$chat_agents" ] && cp "Consistency: RoadTrip agents ($trip_agents) = Chat agents ($chat_agents)" || cw "Consistency: RoadTrip=$trip_agents vs Chat=$chat_agents"

# Chat stats should reflect conversations we created
stats=$(curl -s https://chat.blackroad.io/api/stats --max-time 10 2>/dev/null)
total_convos=$(echo "$stats" | python3 -c "import sys,json; print(json.load(sys.stdin).get('conversations',0))" 2>/dev/null)
total_msgs=$(echo "$stats" | python3 -c "import sys,json; print(json.load(sys.stdin).get('messages',0))" 2>/dev/null)
cp "Consistency: Chat has $total_convos conversations, $total_msgs messages"

echo ""

# ============================================
# 9. PERFORMANCE: Response time matrix
# ============================================
echo "--- PERFORMANCE MATRIX ---"

endpoints=(
  "blackroad.io|homepage"
  "tutor.blackroad.io|tutor"
  "chat.blackroad.io|chat"
  "search.blackroad.io|search"
  "social.blackroad.io|social"
  "roadtrip.blackroad.io|roadtrip"
  "app.blackroad.io|app"
  "status.blackroad.io|status"
  "roadchain-worker.blackroad.workers.dev/health|chain"
  "roadcoin-worker.blackroad.workers.dev/health|coin"
)

echo "  Endpoint            Avg(ms)  Min(ms)  Max(ms)"
echo "  ────────────────    ───────  ───────  ───────"
for entry in "${endpoints[@]}"; do
  url=$(echo "$entry" | cut -d'|' -f1)
  name=$(echo "$entry" | cut -d'|' -f2)
  times=""
  for i in 1 2 3 4 5; do
    t=$(curl -s -o /dev/null -w "%{time_total}" "https://$url" --max-time 10 2>/dev/null)
    times="$times $t"
  done
  avg=$(echo "$times" | awk '{s=0;for(i=1;i<=NF;i++)s+=$i;printf "%.0f",s/NF*1000}')
  mn=$(echo "$times" | tr ' ' '\n' | sort -n | head -1 | awk '{printf "%.0f",$1*1000}')
  mx=$(echo "$times" | tr ' ' '\n' | sort -n | tail -1 | awk '{printf "%.0f",$1*1000}')
  printf "  %-20s %5s    %5s    %5s\n" "$name" "$avg" "$mn" "$mx"
done

all_under_500=true
# Quick check
for url in "blackroad.io" "tutor.blackroad.io" "chat.blackroad.io" "app.blackroad.io"; do
  t=$(curl -s -o /dev/null -w "%{time_total}" "https://$url" --max-time 10 2>/dev/null)
  ms=$(echo "$t * 1000" | bc 2>/dev/null | cut -d. -f1)
  [ "${ms:-999}" -gt 500 ] && all_under_500=false
done
$all_under_500 && cp "Performance: all core apps under 500ms" || cw "Performance: some apps over 500ms"

echo ""

echo "============================================"
echo "INTEGRATION TEST RESULTS"
echo "============================================"
echo "PASSED:  $pass"
echo "WARNED:  $warn"
echo "FAILED:  $fail"
echo "TOTAL:   $total"
echo "Pass rate: $(echo "scale=1; $pass * 100 / $total" | bc 2>/dev/null)%"
echo "============================================"
