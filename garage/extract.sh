#!/bin/bash
# garage/extract.sh — Pull specific files from any repo without cloning
# Usage: bash garage/extract.sh <org/repo> <path> <destination>
# Examples:
#   bash garage/extract.sh BlackRoad-OS-Inc/RoadKey src/auth/vault.java carkeys/
#   bash garage/extract.sh BlackRoad-OS/blackroad-os-prism-enterprise billing/ roadwork/billing/
#   bash garage/extract.sh BlackRoad-OS/blackroad-os-prism-enterprise agents/strategy/ roadtrip/

set -e

REPO="$1"
SRC_PATH="$2"
DEST="$3"

if [ -z "$REPO" ] || [ -z "$SRC_PATH" ] || [ -z "$DEST" ]; then
  echo "Usage: bash garage/extract.sh <org/repo> <path> <destination>"
  echo ""
  echo "Examples:"
  echo "  bash garage/extract.sh BlackRoad-OS-Inc/RoadKey src/auth/ carkeys/auth/"
  echo "  bash garage/extract.sh BlackRoad-OS/blackroad-os-prism-enterprise billing/ roadwork/"
  echo "  bash garage/extract.sh BlackRoad-AI/RoadCode src/ roadcode/src/"
  exit 1
fi

echo "=== GARAGE EXTRACT ==="
echo "Repo: $REPO"
echo "Source: $SRC_PATH"
echo "Destination: $DEST"
echo ""

mkdir -p "$DEST"

# Check if path is a file or directory
contents=$(gh api "repos/$REPO/contents/$SRC_PATH" 2>/dev/null)
type=$(echo "$contents" | python3 -c "import sys,json; d=json.load(sys.stdin); print('dir' if isinstance(d,list) else d.get('type','file'))" 2>/dev/null)

if [ "$type" = "dir" ]; then
  # It's a directory — list and download each file
  files=$(echo "$contents" | python3 -c "
import sys, json
items = json.load(sys.stdin)
for item in items:
    if item['type'] == 'file':
        print(item['path'] + '|' + item['name'])
" 2>/dev/null)

  count=0
  while IFS='|' read -r filepath filename; do
    if [ -n "$filepath" ]; then
      echo "  Extracting: $filename"
      gh api "repos/$REPO/contents/$filepath" -q '.content' 2>/dev/null | base64 -d > "$DEST/$filename" 2>/dev/null
      count=$((count + 1))
    fi
  done <<< "$files"

  echo ""
  echo "Extracted $count files to $DEST"
else
  # It's a single file
  filename=$(basename "$SRC_PATH")
  echo "  Extracting: $filename"
  gh api "repos/$REPO/contents/$SRC_PATH" -q '.content' 2>/dev/null | base64 -d > "$DEST/$filename" 2>/dev/null
  echo "Extracted 1 file to $DEST/$filename"
fi

echo "=== DONE ==="
