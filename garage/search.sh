#!/bin/bash
# garage/search.sh — Search the parts catalog
# Usage: bash garage/search.sh <query>

CATALOG="${2:-garage/parts.json}"
QUERY="$1"

if [ -z "$QUERY" ]; then
  echo "Usage: bash garage/search.sh <query>"
  echo "Examples:"
  echo "  bash garage/search.sh billing"
  echo "  bash garage/search.sh auth"
  echo "  bash garage/search.sh canvas"
  echo "  bash garage/search.sh Python"
  exit 1
fi

if [ ! -f "$CATALOG" ]; then
  echo "Catalog not found. Run: bash garage/scan.sh"
  exit 1
fi

python3 -c "
import json, sys

query = '$QUERY'.lower()
with open('$CATALOG') as f:
    parts = json.load(f)

matches = [p for p in parts if query in p['name'].lower() or query in p.get('description','').lower() or query in p.get('language','').lower()]
matches.sort(key=lambda x: x['size_kb'], reverse=True)

if not matches:
    print(f'No matches for \"{query}\"')
    sys.exit(0)

print(f'Found {len(matches)} matches for \"{query}\":')
print()
print(f'{\"Org\":<25} {\"Repo\":<30} {\"Size\":>8} {\"Language\":<12} {\"Fork\":>5}')
print('-' * 85)
for p in matches[:30]:
    size = f\"{p['size_kb']}KB\" if p['size_kb'] < 1024 else f\"{p['size_kb']//1024}MB\"
    print(f\"{p['org']:<25} {p['name']:<30} {size:>8} {p.get('language','')::<12} {'fork' if p['fork'] else 'orig':>5}\")
"
