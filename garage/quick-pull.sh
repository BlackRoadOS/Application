#!/bin/bash
# garage/quick-pull.sh — Quickly pull the most useful code from known locations
# Usage: bash garage/quick-pull.sh <product>
# Example: bash garage/quick-pull.sh roadwork

set -e

PRODUCT="${1:-all}"

pull_dir() {
  local repo="$1" src="$2" dest="$3" label="$4"
  echo "  Pulling $label from $repo/$src → $dest"
  mkdir -p "$dest"
  bash garage/extract.sh "$repo" "$src" "$dest" 2>/dev/null || echo "    (failed or empty)"
}

case "$PRODUCT" in
  roadwork)
    echo "=== Pulling RoadWork parts ==="
    pull_dir "BlackRoad-OS/blackroad-os-prism-enterprise" "billing" "roadwork/billing" "billing"
    pull_dir "BlackRoad-OS/blackroad-os-prism-enterprise" "crm" "roadwork/crm" "CRM"
    pull_dir "BlackRoad-OS/blackroad-os-prism-enterprise" "sales" "roadwork/sales" "sales"
    pull_dir "BlackRoad-OS/blackroad-os-prism-enterprise" "sales_ops" "roadwork/sales_ops" "sales ops"
    pull_dir "BlackRoad-OS/blackroad-os-prism-enterprise" "support" "roadwork/support" "support"
    pull_dir "BlackRoad-OS/blackroad-os-prism-enterprise" "marketing" "roadwork/marketing" "marketing"
    pull_dir "BlackRoad-OS/blackroad-os-prism-enterprise" "analytics" "roadwork/analytics" "analytics"
    pull_dir "BlackRoad-OS/blackroad-os-prism-enterprise" "legal" "roadwork/legal" "legal"
    pull_dir "BlackRoad-OS/blackroad-os-prism-enterprise" "finance" "roadwork/finance" "finance"
    pull_dir "BlackRoad-OS/blackroad-os-prism-enterprise" "ops" "roadwork/ops" "ops"
    pull_dir "BlackRoad-OS/blackroad-os-prism-enterprise" "dashboard" "roadwork/dashboard" "dashboard"
    ;;
  roadtrip)
    echo "=== Pulling RoadTrip parts ==="
    pull_dir "BlackRoad-OS/blackroad-os-prism-enterprise" "agents" "roadtrip/agents" "agent defs"
    pull_dir "BlackRoad-OS/blackroad-os-prism-enterprise" "agents/strategy" "roadtrip/strategy" "strategy"
    ;;
  roadie)
    echo "=== Pulling Roadie parts ==="
    pull_dir "BlackRoad-OS/blackroad-os-prism-enterprise" "prism-academy" "roadie/academy" "academy"
    ;;
  carkeys)
    echo "=== Pulling CarKeys parts ==="
    pull_dir "BlackRoad-OS/blackroad-os-prism-enterprise" "access" "carkeys/access" "access control"
    pull_dir "BlackRoad-OS/blackroad-os-prism-enterprise" "iam" "carkeys/iam" "IAM"
    pull_dir "BlackRoad-OS/blackroad-os-prism-enterprise" "security" "carkeys/security" "security"
    ;;
  blackboard)
    echo "=== Pulling BlackBoard parts ==="
    pull_dir "BlackRoad-OS/blackroad-os-prism-enterprise" "content" "blackboard/content" "content"
    pull_dir "BlackRoad-OS/blackroad-os-prism-enterprise" "design" "blackboard/design" "design"
    pull_dir "BlackRoad-OS/blackroad-os-prism-enterprise" "frontend" "blackboard/frontend" "frontend"
    ;;
  roadchain)
    echo "=== Pulling RoadChain parts ==="
    pull_dir "BlackRoad-OS/blackroad-os-prism-enterprise" "contracts" "roadchain/contracts" "contracts"
    ;;
  roadview)
    echo "=== Pulling RoadView parts ==="
    pull_dir "BlackRoad-OS/blackroad-os-prism-enterprise" "kg" "roadview/kg" "knowledge graph"
    pull_dir "BlackRoad-OS/blackroad-os-prism-enterprise" "retrieval" "roadview/retrieval" "retrieval"
    ;;
  all)
    echo "=== Pulling ALL product parts ==="
    for p in roadwork roadtrip roadie carkeys blackboard roadchain roadview; do
      bash garage/quick-pull.sh "$p"
      echo ""
    done
    ;;
  *)
    echo "Unknown product: $PRODUCT"
    echo "Available: roadwork roadtrip roadie carkeys blackboard roadchain roadview all"
    ;;
esac

echo ""
echo "=== PULL COMPLETE ==="
