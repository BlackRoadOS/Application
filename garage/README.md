# The Garage

*Where we strip down 2,900 repos and pull the parts that actually run.*

---

## What This Is

The Garage is BlackRoad's extraction and reuse system. We have **37 orgs, 2,900+ repos, and hundreds of GB of code** — most of it forks, experiments, and duplicates. The Garage scans everything, identifies the working parts, extracts them, and wires them into the 14 product directories.

Think of it like a chop shop (the legal kind): cars come in whole, usable parts come out labeled and ready to install.

## How It Works

```
2,900 repos → garage/scan.sh (inventory) → garage/parts.json (catalog)
                                          → garage/extract.sh (pull specific files)
                                          → product directories (installed)
```

### Step 1: Scan — `garage/scan.sh`
Scans all 37 orgs. For each repo: name, size, language, key files, last commit, whether it has a wrangler.toml/package.json/requirements.txt. Outputs `parts.json`.

### Step 2: Catalog — `garage/parts.json`
A searchable index of every repo mapped to which of the 14 products it feeds. Updated by scan.

### Step 3: Extract — `garage/extract.sh <repo> <files> <destination>`
Pulls specific files from any repo without cloning the whole thing. Uses `gh api` for surgical extraction.

### Step 4: Install — copy into the right product directory in Application/

## Quick Commands

```bash
# Scan all orgs (takes ~5 min)
bash garage/scan.sh

# Search the catalog
bash garage/search.sh "billing"
bash garage/search.sh "auth"
bash garage/search.sh "canvas"

# Extract a file from any repo
bash garage/extract.sh BlackRoad-OS-Inc/RoadKey src/auth/vault.java carkeys/

# Extract a whole directory
bash garage/extract.sh BlackRoad-OS/blackroad-os-prism-enterprise agents/ roadtrip/agents/

# Map repos to products
bash garage/map.sh
```

## Product → Repo Mapping (Known)

| Product | Primary Repos | Org |
|---------|--------------|-----|
| BlackRoad OS | app-blackroad | local |
| RoadCode | RoadCode, RoadLang, RoadCodec | AI, Labs, OS-Inc |
| CarPool | RoadStore | OS-Inc |
| OneWay | (build new) | — |
| RoadSide | prism-enterprise/console | OS |
| RoadView | road-search-worker, RoadMetrics | local, OS-Inc |
| RoadTrip | roundtrip-blackroad, RoadChat | local, OS-Inc |
| BackRoad | backroad-social | local |
| RoadWork | RoadHog, RoadCal, prism-enterprise (billing/crm/sales/legal/ops) | OS-Inc, OS |
| Roadie | blackroad-tutor, RoadLearn, RoadCamp | local, OS-Inc |
| BlackBoard | blackroad-canvas, RoadSketch, RoadWrite, RoadTube-Engine | local, OS-Inc |
| CarKeys | carkeys-blackroad, RoadKey | local, OS-Inc |
| RoadChain | roadchain-worker, RoadBase, RoadMoon | local, OS-Inc |
| RoadCoin | roadcoin-worker | local |

## Org Purpose Map

| Org | Purpose | Extract For |
|-----|---------|------------|
| BlackRoad-OS-Inc | Corporate repos, giant Road* forks | All products |
| BlackRoad-OS | Main platform, prism-enterprise | RoadWork, RoadSide, all |
| BlackRoad-AI | AI/ML, Lucidia, RoadCode | RoadTrip, CarPool |
| BlackRoad-Agents | Agent definitions | RoadTrip, RoadWork |
| BlackRoad-Education | Education tools | Roadie |
| BlackRoad-Hardware | Pi fleet, Hailo | Infrastructure |
| BlackRoad-Security | Security tools | CarKeys, RoadChain |
| BlackRoad-Cloud | Cloud/infra | BlackRoad OS |
| BlackRoad-Interactive | Games/interactive | BlackBoard |
| BlackRoad-Media | Media/content | BlackBoard, BackRoad |
| BlackRoad-Studio | Creative tools | BlackBoard |
| BlackRoad-Labs | Research, amundson-constant | RoadChain, math |
| BlackRoad-Quantum | Trinary logic, quantum | RoadChain |
| BlackRoad-Network | Networking | Infrastructure |
| BlackRoad-Archive | 725 archived repos | Search for anything |
| BlackRoad-Forge | 451 forked tools | Extract useful forks |
