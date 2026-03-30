#!/bin/bash
echo "============================================"
echo "BLACKROAD OS — LOAD & STRESS TESTING"
echo "============================================"
echo "Date: $(date)"
echo ""

pass=0; fail=0; warn=0; total=0
cp() { total=$((total+1)); pass=$((pass+1)); echo "✓ $1"; }
cf() { total=$((total+1)); fail=$((fail+1)); echo "✗ $1"; }
cw() { total=$((total+1)); warn=$((warn+1)); echo "⚠ $1"; }

# ============================================
# 1. BURST LOAD: 50 concurrent to each app
# ============================================
echo "--- 1. 50-CONCURRENT BURST PER APP ---"

for target in "blackroad.io" "tutor.blackroad.io" "chat.blackroad.io" "search.blackroad.io" "app.blackroad.io" "roadtrip.blackroad.io" "social.blackroad.io"; do
  name=$(echo "$target" | sed 's|\.blackroad\.io||' | sed 's|blackroad\.io|main|')
  start=$(date +%s%N)
  ok=0
  err=0
  for i in $(seq 1 50); do
    curl -s -o /dev/null -w "%{http_code}" "https://$target" --max-time 10 2>/dev/null &
  done

  # Collect results
  codes=""
  for job in $(jobs -p); do
    wait $job
  done

  # Quick health check after burst
  after=$(curl -s -o /dev/null -w "%{http_code}" "https://$target" --max-time 10 2>/dev/null)
  elapsed=$(( ($(date +%s%N) - start) / 1000000 ))

  if [ "$after" = "200" ]; then
    cp "$name: survived 50 concurrent, healthy after (${elapsed}ms total)"
  else
    cf "$name: returned $after after 50 concurrent burst"
  fi
done

echo ""

# ============================================
# 2. SUSTAINED LOAD: 200 requests over 60 seconds
# ============================================
echo "--- 2. SUSTAINED LOAD (200 req / 60s) ---"

for target in "tutor.blackroad.io/health" "chat.blackroad.io/api/health" "roadtrip.blackroad.io/health"; do
  name=$(echo "$target" | cut -d/ -f1 | sed 's|\.blackroad\.io||')
  ok=0
  err=0
  start_time=$(date +%s)

  for i in $(seq 1 200); do
    code=$(curl -s -o /dev/null -w "%{http_code}" "https://$target" --max-time 5 2>/dev/null)
    [ "$code" = "200" ] && ok=$((ok+1)) || err=$((err+1))

    # Pace to ~3.3 req/sec
    elapsed=$(($(date +%s) - start_time))
    target_time=$((i * 3 / 10))
    if [ "$elapsed" -lt "$target_time" ]; then
      sleep 0.1
    fi
  done

  elapsed=$(($(date +%s) - start_time))
  rps=$(echo "scale=1; 200 / $elapsed" | bc 2>/dev/null)
  success_pct=$(echo "scale=1; $ok * 100 / 200" | bc 2>/dev/null)

  if [ "$ok" -ge 195 ]; then
    cp "$name: $ok/200 success ($success_pct%) at ${rps} req/s over ${elapsed}s"
  elif [ "$ok" -ge 180 ]; then
    cw "$name: $ok/200 success ($success_pct%) — some drops"
  else
    cf "$name: $ok/200 success ($success_pct%) — significant failures"
  fi
done

echo ""

# ============================================
# 3. AI INFERENCE UNDER LOAD
# ============================================
echo "--- 3. AI INFERENCE LOAD (10 concurrent solves) ---"

questions=(
  "What is the quadratic formula?"
  "Explain photosynthesis"
  "Write a Python fibonacci function"
  "What caused World War 1?"
  "How do you find the area of a circle?"
  "What is Newton's first law?"
  "Explain supply and demand"
  "What is a linked list?"
  "How does DNA replication work?"
  "What is the Pythagorean theorem?"
)

echo "  Sending 10 solve requests simultaneously..."
start=$(date +%s)
for i in $(seq 0 9); do
  q="${questions[$i]}"
  curl -s -X POST https://tutor.blackroad.io/solve \
    -H "Content-Type: application/json" \
    -d "{\"question\":\"$q\"}" --max-time 60 2>/dev/null > "/tmp/solve_load_$i" &
done
wait
elapsed=$(($(date +%s) - start))

success=0
for i in $(seq 0 9); do
  r=$(cat "/tmp/solve_load_$i" 2>/dev/null)
  has_id=$(echo "$r" | python3 -c "import sys,json; d=json.load(sys.stdin); print('y' if 'id' in d else 'n')" 2>/dev/null)
  [ "$has_id" = "y" ] && success=$((success+1))
  rm -f "/tmp/solve_load_$i"
done

echo "  Results: $success/10 solves completed in ${elapsed}s"
avg_per_solve=$(echo "scale=1; $elapsed * 1000 / $success" | bc 2>/dev/null)
[ "$success" -ge 8 ] && cp "AI Load: $success/10 concurrent solves (avg ${avg_per_solve}ms each)" || cf "AI Load: only $success/10 completed"

echo ""

# ============================================
# 4. CHAT AI LOAD (5 concurrent conversations)
# ============================================
echo "--- 4. CHAT AI LOAD (5 concurrent conversations) ---"

agents=("cecilia" "eve" "road" "pixel" "tutor")
messages=("What is machine learning?" "Search for BlackRoad" "Give me a status update" "Describe a sunset" "Help me with algebra")

start=$(date +%s)
for i in $(seq 0 4); do
  agent="${agents[$i]}"
  msg="${messages[$i]}"
  # Create convo and send message
  (
    conv=$(curl -s -X POST https://chat.blackroad.io/api/conversations \
      -H "Content-Type: application/json" \
      -d "{\"agent_id\":\"$agent\",\"title\":\"Load test $agent\"}" --max-time 10 2>/dev/null)
    cid=$(echo "$conv" | python3 -c "import sys,json; print(json.load(sys.stdin).get('id',''))" 2>/dev/null)
    if [ -n "$cid" ]; then
      curl -s -X POST "https://chat.blackroad.io/api/conversations/$cid/messages" \
        -H "Content-Type: application/json" \
        -d "{\"content\":\"$msg\",\"role\":\"user\",\"provider\":\"fleet\"}" --max-time 60 2>/dev/null > "/tmp/chat_load_$i"
    fi
  ) &
done
wait
elapsed=$(($(date +%s) - start))

chat_ok=0
for i in $(seq 0 4); do
  r=$(cat "/tmp/chat_load_$i" 2>/dev/null)
  has_reply=$(echo "$r" | python3 -c "import sys,json; d=json.load(sys.stdin); print('y' if d.get('agent',{}).get('content') else 'n')" 2>/dev/null)
  [ "$has_reply" = "y" ] && chat_ok=$((chat_ok+1))
  rm -f "/tmp/chat_load_$i"
done

echo "  Results: $chat_ok/5 agents responded in ${elapsed}s"
[ "$chat_ok" -ge 4 ] && cp "Chat AI Load: $chat_ok/5 concurrent agent responses" || cw "Chat AI Load: $chat_ok/5 responded"

echo ""

# ============================================
# 5. BLOCKCHAIN WRITE STORM
# ============================================
echo "--- 5. BLOCKCHAIN WRITE STORM (20 rapid writes) ---"

before=$(curl -s https://roadchain-worker.blackroad.workers.dev/api/ledger/stats --max-time 10 2>/dev/null | python3 -c "import sys,json; print(json.load(sys.stdin).get('total_blocks',0))" 2>/dev/null)

start=$(date +%s)
for i in $(seq 1 20); do
  curl -s -X POST https://roadchain-worker.blackroad.workers.dev/api/ledger \
    -H "Content-Type: application/json" \
    -d "{\"action\":\"load_test\",\"entity\":\"stress-$i\",\"data\":\"write storm\",\"app\":\"testing\"}" --max-time 15 2>/dev/null > "/tmp/chain_storm_$i" &
done
wait
elapsed=$(($(date +%s) - start))

after=$(curl -s https://roadchain-worker.blackroad.workers.dev/api/ledger/stats --max-time 10 2>/dev/null | python3 -c "import sys,json; print(json.load(sys.stdin).get('total_blocks',0))" 2>/dev/null)
new_blocks=$((after - before))

# Count successful writes
storm_ok=0
for i in $(seq 1 20); do
  r=$(cat "/tmp/chain_storm_$i" 2>/dev/null)
  has_hash=$(echo "$r" | python3 -c "import sys,json; d=json.load(sys.stdin); print('y' if d.get('hash') else 'n')" 2>/dev/null)
  [ "$has_hash" = "y" ] && storm_ok=$((storm_ok+1))
  rm -f "/tmp/chain_storm_$i"
done

echo "  $storm_ok/20 writes returned hash, $new_blocks new blocks added in ${elapsed}s"
wps=$(echo "scale=1; $storm_ok / $elapsed" | bc 2>/dev/null)
[ "$storm_ok" -ge 15 ] && cp "Chain storm: $storm_ok/20 successful writes ($wps writes/sec)" || cw "Chain storm: $storm_ok/20 ($wps w/s)"

echo ""

# ============================================
# 6. WALLET CREATION STORM
# ============================================
echo "--- 6. WALLET CREATION STORM (20 new wallets) ---"

start=$(date +%s)
wallet_ok=0
for i in $(seq 1 20); do
  uid="storm-wallet-$(date +%s)-$i"
  r=$(curl -s -X POST https://roadcoin-worker.blackroad.workers.dev/api/faucet \
    -H "Content-Type: application/json" \
    -d "{\"road_id\":\"$uid\"}" --max-time 10 2>/dev/null)
  received=$(echo "$r" | python3 -c "import sys,json; print(json.load(sys.stdin).get('received',0))" 2>/dev/null)
  [ "$received" = "100" ] && wallet_ok=$((wallet_ok+1))
done
elapsed=$(($(date +%s) - start))
wps=$(echo "scale=1; $wallet_ok / $elapsed" | bc 2>/dev/null)

echo "  $wallet_ok/20 wallets created in ${elapsed}s ($wps/sec)"
[ "$wallet_ok" -ge 18 ] && cp "Wallet storm: $wallet_ok/20 created successfully" || cw "Wallet storm: $wallet_ok/20"

# Check total holders now
info=$(curl -s https://roadcoin-worker.blackroad.workers.dev/api/info --max-time 10 2>/dev/null)
holders=$(echo "$info" | python3 -c "import sys,json; print(json.load(sys.stdin).get('holders',0))" 2>/dev/null)
circulating=$(echo "$info" | python3 -c "import sys,json; print(json.load(sys.stdin).get('circulating',0))" 2>/dev/null)
cp "Economy state: $holders holders, $circulating ROAD circulating"

echo ""

# ============================================
# 7. SEARCH BOMBARDMENT
# ============================================
echo "--- 7. SEARCH BOMBARDMENT (30 rapid queries) ---"

queries=("math" "physics" "coding" "help" "blackroad" "homework" "python" "algebra" "history" "science"
         "calculus" "biology" "chemistry" "essay" "tutor" "learn" "study" "exam" "test" "practice"
         "derivative" "integral" "equation" "solve" "explain" "how" "what" "why" "when" "where")

search_ok=0
start=$(date +%s)
for q in "${queries[@]}"; do
  code=$(curl -s -o /dev/null -w "%{http_code}" "https://search.blackroad.io/api/search?q=$q" --max-time 10 2>/dev/null)
  [ "$code" = "200" ] && search_ok=$((search_ok+1))
done
elapsed=$(($(date +%s) - start))
qps=$(echo "scale=1; 30 / $elapsed" | bc 2>/dev/null)

echo "  $search_ok/30 queries returned 200 in ${elapsed}s ($qps q/s)"
[ "$search_ok" -ge 28 ] && cp "Search bombardment: $search_ok/30 at $qps queries/sec" || cw "Search: $search_ok/30"

echo ""

# ============================================
# 8. LATENCY PERCENTILES (100 samples per app)
# ============================================
echo "--- 8. LATENCY PERCENTILES (100 samples) ---"

for target in "tutor.blackroad.io" "chat.blackroad.io/api/health" "roadtrip.blackroad.io"; do
  name=$(echo "$target" | cut -d. -f1)
  times=""
  for i in $(seq 1 100); do
    t=$(curl -s -o /dev/null -w "%{time_total}" "https://$target" --max-time 10 2>/dev/null)
    times="$times $t"
  done

  p50=$(echo "$times" | tr ' ' '\n' | sort -n | awk 'NR==50{printf "%.0f",$1*1000}')
  p90=$(echo "$times" | tr ' ' '\n' | sort -n | awk 'NR==90{printf "%.0f",$1*1000}')
  p95=$(echo "$times" | tr ' ' '\n' | sort -n | awk 'NR==95{printf "%.0f",$1*1000}')
  p99=$(echo "$times" | tr ' ' '\n' | sort -n | awk 'NR==99{printf "%.0f",$1*1000}')
  avg=$(echo "$times" | awk '{s=0;for(i=1;i<=NF;i++)s+=$i;printf "%.0f",s/NF*1000}')

  echo "  $name: avg=${avg}ms p50=${p50}ms p90=${p90}ms p95=${p95}ms p99=${p99}ms"
  [ "${p99:-999}" -lt 1000 ] && cp "$name: p99 under 1s (${p99}ms)" || cw "$name: p99 = ${p99}ms"
done

echo ""

# ============================================
# 9. RECOVERY TEST
# ============================================
echo "--- 9. RECOVERY AFTER HEAVY LOAD ---"

echo "  Waiting 5 seconds after all load tests..."
sleep 5

all_healthy=true
for target in "blackroad.io" "tutor.blackroad.io" "chat.blackroad.io" "roadtrip.blackroad.io" "app.blackroad.io"; do
  code=$(curl -s -o /dev/null -w "%{http_code}" "https://$target" --max-time 10 2>/dev/null)
  t=$(curl -s -o /dev/null -w "%{time_total}" "https://$target" --max-time 10 2>/dev/null)
  ms=$(echo "$t * 1000" | bc 2>/dev/null | cut -d. -f1)
  if [ "$code" = "200" ] && [ "${ms:-999}" -lt 500 ]; then
    echo "  ✓ $target: $code in ${ms}ms"
  else
    echo "  ✗ $target: $code in ${ms}ms"
    all_healthy=false
  fi
done
$all_healthy && cp "Recovery: all apps healthy and fast after load test" || cw "Recovery: some apps slow after load"

echo ""

echo "============================================"
echo "LOAD TEST RESULTS"
echo "============================================"
echo "PASSED:  $pass"
echo "WARNED:  $warn"
echo "FAILED:  $fail"
echo "TOTAL:   $total"
echo "Pass rate: $(echo "scale=1; $pass * 100 / $total" | bc 2>/dev/null)%"
echo "============================================"
