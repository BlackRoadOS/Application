#!/bin/bash
# garage/scan.sh — Scan all 37 orgs and build parts catalog
# Usage: bash garage/scan.sh [output_file]

set -e

OUTPUT="${1:-garage/parts.json}"
ORGS=$(gh api user/memberships/orgs --paginate -q '.[].organization.login' 2>/dev/null | sort)

echo "=== GARAGE SCAN ==="
echo "Scanning all orgs for usable parts..."
echo ""

echo "[" > "$OUTPUT"
first=true

for org in $ORGS; do
  echo "Scanning $org..."
  repos=$(gh api "orgs/$org/repos" --paginate -q '.[] | @base64' 2>/dev/null)

  for repo_b64 in $repos; do
    repo=$(echo "$repo_b64" | base64 -d 2>/dev/null)
    name=$(echo "$repo" | python3 -c "import sys,json; print(json.load(sys.stdin)['name'])" 2>/dev/null)
    size=$(echo "$repo" | python3 -c "import sys,json; print(json.load(sys.stdin)['size'])" 2>/dev/null)
    lang=$(echo "$repo" | python3 -c "import sys,json; print(json.load(sys.stdin).get('language',''))" 2>/dev/null)
    updated=$(echo "$repo" | python3 -c "import sys,json; print(json.load(sys.stdin)['updated_at'])" 2>/dev/null)
    fork=$(echo "$repo" | python3 -c "import sys,json; print(json.load(sys.stdin)['fork'])" 2>/dev/null)
    desc=$(echo "$repo" | python3 -c "import sys,json; print(json.load(sys.stdin).get('description','') or '')" 2>/dev/null)

    # Skip tiny repos
    [ "${size:-0}" -lt 10 ] && continue

    if [ "$first" = true ]; then
      first=false
    else
      echo "," >> "$OUTPUT"
    fi

    cat >> "$OUTPUT" << ENTRY
  {"org":"$org","name":"$name","size_kb":$size,"language":"$lang","updated":"$updated","fork":$fork,"description":"$(echo "$desc" | sed 's/"/\\"/g' | head -c 100)"}
ENTRY
  done
done

echo "" >> "$OUTPUT"
echo "]" >> "$OUTPUT"

total=$(python3 -c "import json; print(len(json.load(open('$OUTPUT'))))" 2>/dev/null)
echo ""
echo "=== SCAN COMPLETE ==="
echo "Total repos cataloged: $total"
echo "Output: $OUTPUT"
