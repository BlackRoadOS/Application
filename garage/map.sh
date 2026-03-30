#!/bin/bash
# garage/map.sh — Map repos to products by name pattern matching
# Usage: bash garage/map.sh

CATALOG="${1:-garage/parts.json}"

if [ ! -f "$CATALOG" ]; then
  echo "Catalog not found. Run: bash garage/scan.sh first"
  exit 1
fi

python3 << 'PYEOF'
import json

with open("garage/parts.json") as f:
    parts = json.load(f)

# Product keywords to match
products = {
    "BlackRoad OS": ["blackroad-os", "app-blackroad", "browser-os", "desktop", "prismos"],
    "RoadCode": ["roadcode", "roadlang", "roadcodec", "vscode", "code-editor", "claude-code"],
    "CarPool": ["carpool", "roadstore", "integration", "import", "connector"],
    "OneWay": ["oneway", "export", "migration", "data-port"],
    "RoadSide": ["roadside", "onboard", "setup", "wizard", "welcome"],
    "RoadView": ["roadview", "search", "roadmetrics", "perplexity"],
    "RoadTrip": ["roadtrip", "roundtrip", "roadchat", "agent-chat", "convoy"],
    "BackRoad": ["backroad", "social", "autopilot", "posting", "content-auto"],
    "RoadWork": ["roadwork", "roadhog", "roadcal", "billing", "crm", "invoice", "support-ticket", "sales-ops"],
    "Roadie": ["roadie", "tutor", "roadlearn", "roadcamp", "education", "homework", "socratic"],
    "BlackBoard": ["blackboard", "roadsketch", "roadwrite", "roadtube", "canvas", "content-create", "video-edit"],
    "CarKeys": ["carkeys", "roadkey", "credential", "vault", "auth-key", "passkey"],
    "RoadChain": ["roadchain", "roadbase", "roadmoon", "blockchain", "hash-chain", "ledger", "provenance"],
    "RoadCoin": ["roadcoin", "token", "faucet", "earn-reward"],
}

mapped = {p: [] for p in products}
unmapped = []

for part in parts:
    name_lower = part["name"].lower()
    desc_lower = (part.get("description", "") or "").lower()
    found = False

    for product, keywords in products.items():
        for kw in keywords:
            if kw in name_lower or kw in desc_lower:
                mapped[product].append(part)
                found = True
                break
        if found:
            break

    if not found and part["size_kb"] > 100:
        unmapped.append(part)

print("=" * 70)
print("PRODUCT → REPO MAPPING")
print("=" * 70)
print()

for product, repos in mapped.items():
    if repos:
        repos.sort(key=lambda x: x["size_kb"], reverse=True)
        total_mb = sum(r["size_kb"] for r in repos) // 1024
        print(f"[{product}] — {len(repos)} repos, ~{total_mb}MB total")
        for r in repos[:5]:
            size = f"{r['size_kb']}KB" if r["size_kb"] < 1024 else f"{r['size_kb']//1024}MB"
            print(f"  {r['org']}/{r['name']} ({size}, {r.get('language','')})")
        if len(repos) > 5:
            print(f"  ... +{len(repos)-5} more")
        print()
    else:
        print(f"[{product}] — NO REPOS FOUND (build from scratch)")
        print()

if unmapped:
    print(f"\n[UNMAPPED] — {len(unmapped)} repos >100KB not assigned to any product")
    for r in unmapped[:10]:
        size = f"{r['size_kb']}KB" if r["size_kb"] < 1024 else f"{r['size_kb']//1024}MB"
        print(f"  {r['org']}/{r['name']} ({size}, {r.get('language','')})")
    if len(unmapped) > 10:
        print(f"  ... +{len(unmapped)-10} more")

PYEOF
