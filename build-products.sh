#!/bin/bash
# Build and deploy 15 BlackRoad product HTML pages to Gematria
# Usage: ./build-products.sh

set -e

OUT="/tmp/product-pages"
rm -rf "$OUT"
mkdir -p "$OUT"

# ── Product Data ──────────────────────────────────────────────
# Format: slug|name|tagline|subtitle|color|url|subdomain|stats
PRODUCTS=(
  "os|BlackRoad OS|Open a tab. Open your world.|Browser desktop OS|#FF2255|https://app.blackroad.io|app|3 Road Modes|14 Layers|Cross-Device Sync|Offline-First"
  "roadcode|RoadCode|Write it. Ship it. From anywhere.|Code editor + deploy|#FF2255|https://roadcode.blackroad.io|roadcode|AI Co-Pilot|One-Click Deploy|14 Ship Tools|RoadChain Stamps"
  "carpool|CarPool|Your AIs, riding together.|AI-to-AI integration hub|#8844FF|https://chat.blackroad.io|chat|Memory Bridge|Cost Optimizer|14 Triggers|Multi-AI Fusion"
  "oneway|OneWay|Your data leaves when you say. Never look back.|Data export|#00D4FF|https://oneway.blackroad.io|oneway|Delta Packing|6 Templates|Burn Keys|RoadChain Manifest"
  "roadside|RoadSide|Pull over. We will take it from here.|Onboarding help agent|#4488FF|https://roadside.blackroad.io|roadside|Ride Quiz|8 Templates|Voice Setup|Welcome Bonus"
  "roadview|RoadView|See the road ahead. Every answer verified.|Search + verification|#4488FF|https://search.blackroad.io|search|Confidence Gauge|Memory-First|14 Filters|Verified Reports"
  "roadtrip|RoadTrip|Pick up your passengers. They never forget the ride.|Agent orchestration|#CC00AA|https://roadtrip.blackroad.io|roadtrip|18 AI Agents|8 Channels|Ride Replay|Convoy Radio"
  "backroad|BackRoad|The scenic route. Your content, everywhere.|Universal social|#00D4FF|https://social.blackroad.io|social|Viral Pulse|Cross-Platform|Agent Reputation|Echo Engine"
  "roadwork|RoadWork|Construction ahead. Your business builds itself.|Company automation|#FF6B2B|https://work.blackroad.io|work|7 Agents|Crew Huddles|Risk Radar|Voice Steer"
  "roadie|Roadie|The patient friend in the passenger seat.|AI tutor|#FF6B2B|https://tutor.blackroad.io|tutor|6 Modes|Socratic Engine|Portfolio Builder|Learning Expeditions"
  "blackboard|BlackBoard|Make it. Post it. The billboard is yours.|Content generation|#CC00AA|https://blackboard.blackroad.io|blackboard|Campaign Maps|Style Tracker|A/B Testing|Template Market"
  "carkeys|CarKeys|Grab your keys. You are not going anywhere without them.|Credential vault|#8844FF|https://carkeys.blackroad.io|carkeys|Trust Scores|Key Rotation|Family Keys|Quantum-Safe"
  "roadchain|RoadChain|Every mile, stamped and sealed.|Blockchain verification|#FF2255|https://chain.blackroad.io|chain|Chain Explorer|Proof Links|ZK Proofs|Carbon Negative"
  "roadcoin|RoadCoin|Drive the road. Earn the fuel.|Token economy|#FF6B2B|https://coin.blackroad.io|coin|Fuel Gauge|Marketplace|Staking|Leaderboard"
  "roadworld|RoadWorld|Build worlds. Play forever.|Custom AI game engine|#9C27B0|https://roadworld.blackroad.io|roadworld|World Builder|AI NPCs|Multiplayer|RoadCoin Rewards"
)

# ── Product connections (from WORKFLOWS.md) ──────────────────
declare -A CONNECTIONS
CONNECTIONS[os]="CarKeys authenticates you|RoadSide checks setup|All 14 products launch from the dock|Persistent state syncs across devices"
CONNECTIONS[roadcode]="Claude co-pilot in editor|Deploy triggers RoadWork invoicing|Commits stamped on RoadChain|BackRoad posts the launch"
CONNECTIONS[carpool]="Import external AI conversations|Hands to RoadTrip agents|Verified by RoadView|Sent to BlackBoard for visuals"
CONNECTIONS[oneway]="Nightly delta exports run|Full manifest with RoadChain proof|Exports Shared Memory and assets|Includes RoadCode and RoadWork logs"
CONNECTIONS[roadside]="Auto-imports your data|Creates CarKeys credentials|Pre-loads recommended agents|Hands off to CarPool for AI imports"
CONNECTIONS[roadview]="Searches your data first|Then web and blockchain|Ask the Convoy hands to RoadTrip|Results feed BlackBoard and RoadWork"
CONNECTIONS[roadtrip]="Eve researches the topic|Pixel designs the visuals|Cadence writes the copy|BackRoad posts and RoadWork tracks"
CONNECTIONS[backroad]="Content from any product|Auto-formatted and scheduled|Agents engage on your behalf|Performance feeds RoadView and RoadCoin"
CONNECTIONS[roadwork]="7 agents execute your goals|Auto-invoice on new sales|Support follow-up triggered|Crew huddles summarize weekly"
CONNECTIONS[roadie]="Socratic guidance session|RoadView verifies facts|BlackBoard creates visual aids|Portfolio saved on RoadChain"
CONNECTIONS[blackboard]="Generate assets from prompts|RoadTrip agents collaborate|RoadChain stamps provenance|BackRoad distributes everywhere"
CONNECTIONS[carkeys]="Biometric login authenticates|Auto-rotates credentials|Scoped keys for agent access|All actions logged on RoadChain"
CONNECTIONS[roadchain]="Every action hashed and anchored|Powers proof in RoadView|Provenance in BlackBoard|Audit trail in RoadWork"
CONNECTIONS[roadcoin]="Earn on actions across products|Spend in the Marketplace|Stake for governance votes|Complete rides to earn more"
CONNECTIONS[roadworld]="Build custom AI worlds|NPCs powered by RoadTrip agents|Assets from BlackBoard|Progress on RoadChain"

# ── Product integrations ─────────────────────────────────────
declare -A INTEGRATIONS
INTEGRATIONS[os]="Shared Memory|RoadChain|RoadCoin|CarKeys|RoadSide|RoadView|RoadTrip"
INTEGRATIONS[roadcode]="Shared Memory|RoadChain|RoadCoin|RoadWork|BackRoad|BlackBoard"
INTEGRATIONS[carpool]="Shared Memory|RoadChain|RoadCoin|RoadTrip|RoadView|BlackBoard"
INTEGRATIONS[oneway]="Shared Memory|RoadChain|RoadCoin|RoadCode|RoadWork|BlackBoard"
INTEGRATIONS[roadside]="Shared Memory|RoadChain|RoadCoin|CarPool|CarKeys|RoadView"
INTEGRATIONS[roadview]="Shared Memory|RoadChain|RoadCoin|RoadTrip|BlackBoard|RoadWork"
INTEGRATIONS[roadtrip]="Shared Memory|RoadChain|RoadCoin|BackRoad|RoadWork|BlackBoard"
INTEGRATIONS[backroad]="Shared Memory|RoadChain|RoadCoin|RoadView|BlackBoard|RoadWork"
INTEGRATIONS[roadwork]="Shared Memory|RoadChain|RoadCoin|RoadCode|BackRoad|RoadView"
INTEGRATIONS[roadie]="Shared Memory|RoadChain|RoadCoin|RoadView|BlackBoard|RoadTrip"
INTEGRATIONS[blackboard]="Shared Memory|RoadChain|RoadCoin|RoadTrip|BackRoad|Roadie"
INTEGRATIONS[carkeys]="Shared Memory|RoadChain|RoadCoin|RoadSide|RoadWork|CarPool"
INTEGRATIONS[roadchain]="Shared Memory|RoadCoin|RoadView|BlackBoard|OneWay|RoadWork"
INTEGRATIONS[roadcoin]="Shared Memory|RoadChain|BlackBoard|RoadTrip|RoadWork|BackRoad"
INTEGRATIONS[roadworld]="Shared Memory|RoadChain|RoadCoin|RoadTrip|BlackBoard|Roadie"

# ── Features (v1 + v2 combined per product) ──────────────────
# Each feature: "Name --- Description"
declare -A FEATURES

FEATURES[os]=$(cat <<'FEAT'
Road Modes --- Switch between Cruise (minimalist), Convoy (agent overlays), and Night Drive (dark highway accents)
App Dock with Live Indicators --- See which agents are active with glowing fuel-gauge style indicators
QuickSwitch Hotkeys --- Cmd/Ctrl + number to jump between open windows or products instantly
Offline-First Sync --- Full desktop works offline with automatic sync; RoadChain stamps queue and apply later
Highway Layers --- Toggle Surface (clean), Convoy (agent overlays), Deep Map (Shared Memory visualization)
Smart Window Grouping --- Auto-groups related windows with highway-line connectors
Voice Command Center --- Global voice control with convoy awareness
Ride Snapshot --- One-tap save/restore of desktop state including windows, agents, and memory
Dynamic Fuel HUD --- Live RoadCoin counter with trend arrow and predicted earnings
Cross-Device Handover --- Transfer sessions between devices with passing the wheel animation
Theme Engine --- Community-shared road-themed UI packs (Neon Highway, Classic Asphalt, Sunset Drive)
Focus Convoy --- Hide all but essential agents and products for deep work
Activity Heatmap --- Visual overlay of time spent across the highway
Quick Export Bar --- Persistent OneWay export for selected windows or full desktop
Agent Handoff Gestures --- Drag windows onto agent avatars to hand context
Road Memory Search --- Global search across Shared Memory in all products
Performance Lane --- System performance as highway lanes (green smooth, yellow congested)
Legacy Mode --- Classic desktop for minimal road theming
FEAT
)

FEATURES[roadcode]=$(cat <<'FEAT'
Agent Pair Programming --- Claude or any AI joins your editor as a live co-pilot with diff view and voice comments
One-Click Ship to RoadWork --- Deployed code triggers business logic (invoicing, announcements) in RoadWork
RoadTest Suite --- AI-generated tests that run in-browser with visual road-sign pass/fail indicators
Commit Storytelling --- Every commit gets a narrative summary generated by Cadence for BackRoad posting
Convoy Code Review --- Multiple agents review with color-coded suggestions
Live Deploy Preview --- Simulated production inside the editor
RoadCommit Stories --- Cadence generates narrative commit summaries for BackRoad
Agent Branching --- Parallel what-if branches where agents experiment
Code Memory Recall --- Pull past snippets from Shared Memory with one command
Visual Debugger Overlay --- Road-sign breakpoints and error markers with explanations
Ship and Announce --- Deploy plus auto-create BackRoad post and RoadWork notification
Style Guardrails --- Enforce coding standards learned from previous projects
Pair Programming Timer --- Structured sessions with agent rotation and breaks
Test Road Map --- Visual coverage map of tested codebase
Quantum-Safe Code Scanner --- Flags crypto code needing post-quantum updates
RoadCoin Bounty Mode --- Offer rewards for agents that find and fix bugs
Export as Learning Asset --- Turn code patterns into Roadie teaching modules
Highway Deploy Log --- Timeline of deploys with RoadChain stamps and metrics
FEAT
)

FEATURES[carpool]=$(cat <<'FEAT'
Memory Bridge --- Instantly bridge memories between two external AIs for different perspectives
Convoy Cost Optimizer --- Suggests the cheapest model combination for a task while maintaining quality
Import Health Dashboard --- Shows which imported conversations are healthy vs stale with one-click refresh
Silent Observer Mode --- Let agents watch a conversation without interrupting, then summarize when asked
Memory Fusion Tool --- Merge two AI conversations with conflict resolution
Convoy Cost Simulator --- Preview token usage and cost before multi-agent workflows
Silent Observer Agents --- Watch without speaking, summarize later
Trigger Recipe Library --- Community and personal reusable hand-off sequences
Import Conflict Resolver --- Smart merge when imported threads overlap existing memory
Agent Permission Matrix --- Visual grid of what each agent can see and do
Cross-Product Trigger Map --- All active triggers across the highway in one view
Memory Health Score --- Freshness and relevance of imported vs native memory
One-Way Bridge Mode --- Temporary one-directional flow from external AI
Convoy Handoff Visualizer --- Animated flowchart of context movement
Learning Feedback Loop --- Agents learn from successful vs failed hand-offs
Privacy Shield Presets --- Quick templates (Family Safe, Business Confidential, Creative Open)
RoadCoin Collaboration Bonus --- Extra rewards for multi-AI workflow completion
Exportable Convoy Blueprint --- Save and share successful multi-AI setups
FEAT
)

FEATURES[oneway]=$(cat <<'FEAT'
Smart Delta Packing --- Only exports changes since last pack with visual trunk weight indicator
Destination Templates --- Pre-built packs for personal archive, accountant, compliance officer
Export Preview --- See exactly what will be sent before it leaves with redaction suggestions
Reverse Audit --- See what has been successfully received on the destination side
Smart Redaction Studio --- Visual editor to preview and redact before export
Destination Health Monitor --- Live status of all export endpoints
Delta Change Highlight --- Color-coded preview of changes since last export
Scheduled Smart Packs --- Rule-based exports like RoadWork financials every Friday
Export Templates --- Pre-built packs for accountant, compliance, backup, migration
Reverse Verification --- Confirm receipt and integrity on destination side
RoadChain Manifest Viewer --- Visual manifest of everything in an export
Bulk Export History --- Timeline with search and re-export options
Privacy Score --- Sensitive data indicator with redaction suggestions
One-Time Burn Keys --- Single-use outbound keys for high-security exports
Learning Export Patterns --- System suggests better rules from your behavior
Convoy Export Summary --- Agent-generated human-readable summary
Carbon Impact of Export --- Environmental cost and savings of your choices
Legacy Archive Mode --- Long-term cold storage with extra RoadChain anchoring
FEAT
)

FEATURES[roadside]=$(cat <<'FEAT'
Ride Style Quiz --- Short playful quiz during onboarding that recommends optimal agent lineup and settings
Template Library --- Save multiple ride profiles (Creator, Family, Enterprise) and switch with one tap
Progress Celebration --- Animated highway arrival animation when onboarding completes with RoadCoin bonus
Re-Onboarding Shortcut --- Pull over again button that lets you redo any part without losing progress
Ride Personality Quiz --- Fun quiz that builds personalized starting config
Saved Ride Templates --- Store and switch setups (Creator, Family, Enterprise)
Progress Celebration Sequence --- Animated highway arrival with convoy cheering
Partial Re-Onboarding --- Redo specific sections without resetting everything
Import Conflict Preview --- Shows overlaps before pulling external data
Agent Preview Mode --- Test-drive recommended agents before committing
Voice-First Onboarding --- Complete setup entirely through voice
Family Profile Builder --- Guided linked family accounts with safeguards
RoadCoin Welcome Bonus --- Starting bonus based on setup completeness
Setup Health Score --- Dashboard of highway configuration quality
Quick Reset Shortcuts --- One-tap reset for individual products
Learning Style Detector --- Analyzes early usage and suggests Roadie settings
Convoy Introduction Tour --- Agents introduce themselves in guided tour
Export Setup Blueprint --- Save entire configuration as shareable template
FEAT
)

FEATURES[roadview]=$(cat <<'FEAT'
Answer Confidence Gauge --- Fuel-gauge style meter showing how verified and complete each answer is
Road Ahead Predictions --- AI suggests related future questions based on your search patterns
Memory-Augmented Search --- Automatically includes relevant Shared Memory results without explicit prompting
Export as Verified Report --- Turn any search into a RoadChain-stamped PDF or Notion page
Confidence Highway Gauge --- Fuel-gauge showing answer reliability
Predictive Road Ahead --- Suggests next questions from search history
Memory-First Results --- Prioritizes Shared Memory automatically
Verified Report Builder --- Turn search into RoadChain-stamped PDF
Filter Presets --- Only My Data, Blockchain Verified Only, Learning Mode
Agent Ask Mode --- Hand search to specific agents for deeper analysis
Search History Road Map --- Visual timeline of searches and connections
Freshness Indicators --- Source currency with road-sign styling
Collaborative Search --- Invite convoy to refine or expand searches
Export as Learning Asset --- Convert answers into Roadie study materials
Privacy Shielded Search --- Temporarily hide memory categories from results
Performance Insights --- Which question types get best verified answers
RoadCoin Reward for Good Searches --- Bonus for highly-rated searches
Deep Archive Mode --- Include Cold Layer for maximum historical context
FEAT
)

FEATURES[roadtrip]=$(cat <<'FEAT'
Convoy Playlist --- Agents collaboratively build a themed playlist of music, quotes, or learning resources
Emotion Check-ins --- Agents notice when you seem frustrated or excited and offer supportive interventions
Guest Passenger Mode --- Temporarily invite external users or AIs with scoped memory access
Ride Replay --- Watch an animated replay of a past RoadTrip with key moments highlighted
Convoy Playlist Builder --- Agents collaboratively create themed playlists
Emotion-Aware Interventions --- Agents notice mood and offer supportive check-ins
Guest Passenger Invites --- Add external users and AIs with scoped access
Ride Replay Theater --- Animated replay with highlighted key moments
Topic Auto-Threading --- Intelligent separation into clean project threads
Memory Milestone Celebrations --- Animations when major insights consolidated
Voice-First Convoy Radio --- Background listening while working elsewhere
Cross-Product Trigger Gallery --- Browse and apply successful hand-off patterns
Agent Role Rotation --- Structured swapping for balanced input
Shared Whiteboard --- Visual canvas for agents and you together
Learning Convoy Mode --- Optimized for group study with Roadie
Privacy Bubble --- Temporarily isolate thread from Shared Memory
RoadCoin Convoy Bonus --- Extra rewards for meaningful group contribution
End-of-Ride Summary --- Generated recap with RoadChain-stamped highlights
FEAT
)

FEATURES[backroad]=$(cat <<'FEAT'
Viral Pulse Detector --- Alerts you when a post is gaining traction and suggests agent actions to amplify
Cross-Platform Echo --- Automatically creates echo posts on secondary platforms based on performance
Agent Reputation Score --- Each agent builds its own follower base and reputation across platforms
Seasonal Campaign Templates --- Pre-built road-trip themed campaigns for holidays or business cycles
Viral Pulse Monitor --- Real-time alerts with amplification suggestions
Cross-Platform Echo Engine --- Auto-adapts successful posts for other platforms
Agent Reputation Builder --- Each agent develops its own audience metrics
Seasonal Campaign Library --- Themed templates for holidays and cycles
Engagement Quality Scoring --- Rewards meaningful over vanity metrics
Ghost Campaign Simulator --- Full preview including predicted agent replies
Audience Insight Feed --- Live digest of audience response patterns
Collaborative Posting --- Multiple users and agents co-author campaigns
Reply Style Trainer --- Direct feedback to improve agent reply quality
Performance Road Map --- Visual timeline across platforms
Licensing Quick-Sell --- One-tap offer to license posts or templates
Convoy Boost Mode --- Multi-agent coordinated natural activity
Sentiment Shield --- Auto-protection against toxic threads
RoadCoin Engagement Multiplier --- Higher rewards for real conversations
FEAT
)

FEATURES[roadwork]=$(cat <<'FEAT'
Crew Huddle --- Weekly automated meeting where all 7 agents summarize progress and propose adjustments
Risk Radar --- Legal Lookout and Analytics Atlas jointly flag potential issues before they become problems
Growth Accelerator --- Growth Guide suggests new revenue experiments based on past performance data
Steer Mode Voice Commands --- Talk to the crew hands-free to control operations
Crew Huddle Summaries --- Weekly automated meetings with adjustments
Risk Radar Dashboard --- Joint Legal plus Analytics alerts
Growth Experiment Lab --- Data-driven revenue test suggestions
Voice Steer Commands --- Hands-free instructions to the crew
Workflow Recipe Library --- Community reusable automation templates
Agent Workload Balancer --- Automatic fair task distribution
Compliance Snapshot --- Instant RoadChain-verified overview
Financial Fuel Gauge --- Live cash flow visualization
Customer Journey Map --- Visual highway of customer movement
Automated Report Narratives --- Cadence-generated executive summaries
Team Onboarding Flow --- RoadSide-style employee setup with scoped keys
Performance Incentive Engine --- RoadCoin bonuses tied to KPIs
Scenario Planner --- What-if business decision simulations
Legacy Archive Mode --- Long-term business record export
FEAT
)

FEATURES[roadie]=$(cat <<'FEAT'
Learning Road Trip Mode --- Turns a full subject into a multi-week guided journey with checkpoints
Parent/Teacher Co-Pilot --- Real-time shared view where parents and teachers can watch and add notes
Portfolio Builder --- Assembles verified Show Your Work artifacts into shareable learning passports
Fun Detours --- Occasional educational games or challenges that earn extra RoadCoin
Learning Expedition Mode --- Multi-week guided subject journeys
Parent/Teacher Co-Pilot Dashboard --- Real-time shared view with privacy controls
Portfolio Auto-Builder --- RoadChain-verified learning passports
Fun Road Detours --- Educational games earning RoadCoin
Concept Heatmap --- Visual mastery map with highway styling
Socratic Difficulty Slider --- Adjust question challenge level
Group Study Convoy --- RoadTrip integration for collaborative learning
Progress Celebration Scenes --- Animated milestone arrivals
Voice-First Bedtime Mode --- Gentle evening review sessions
Teacher Dashboard Integration --- Seamless classroom tool sync
Personalized Road Map --- Each student unique learning highway
Reflection Prompts --- End-of-session deepening questions
Achievement Badge Gallery --- Visual badge collection
Export as Verified Transcript --- RoadChain-stamped session records
FEAT
)

FEATURES[blackboard]=$(cat <<'FEAT'
Campaign Road Map --- Visual timeline showing how a campaign will unfold across platforms and time
Style Evolution Tracker --- Learns and refines your brand voice over time from your feedback
Collaborative Billboards --- Multiple users or agents work on the same canvas with RoadChain version history
Royalty Dashboard --- Real-time view of how much RoadCoin earned from licensed assets
Campaign Road Map Timeline --- Visual multi-platform rollout planner
Brand Voice Evolution Tracker --- Learns and refines your tone
Real-Time Collaborative Canvas --- Multiple agents and users editing together
Royalty Earnings Dashboard --- Live RoadCoin from licensed assets
Style Guardrail Editor --- Fine-tune AI generation boundaries
A/B Test Highway --- Visual creative variant comparison
Stock Asset Smart Matcher --- Suggests licensed media for your brand
Motion Preview Theater --- Animated video output preview
Campaign Performance Predictor --- Estimates reach before publishing
Template Marketplace --- Buy and sell RoadCoin-priced templates
Version History Road Log --- Timeline of changes with RoadChain stamps
Export as Learning Asset --- Turn campaigns into Roadie materials
Convoy Brainstorm Mode --- All agents contribute ideas
Final Polish Assistant --- One-tap review and optimization
FEAT
)

FEATURES[carkeys]=$(cat <<'FEAT'
Key Health Dashboard --- Shows trust scores, rotation status, and security posture of every device
Emergency Convoy Lockdown --- One command that temporarily restricts all agents until you confirm safety
Family Key Sharing --- Create limited learner keys for kids with Roadie monitoring
Security Adventure Mode --- Fun challenges that teach better practices and award RoadCoin
Device Trust Timeline --- Visual device add and remove history
Hybrid Quantum Safety Indicator --- Post-quantum protection level
One-Tap Key Rotation --- Manual and scheduled rotation with RoadChain proof
Guest Key Builder --- Time-limited scoped collaborator keys
Lost Key Recovery Theater --- Guided animated recovery
Biometric Gesture Library --- Custom login gestures
Security Audit Export --- RoadChain-verified security history
Agent Access Log --- Which agents used which keys and when
Key Strength Visualizer --- Fuel-gauge vault security meter
Future-Proof Mode --- Prep for upcoming post-quantum standards
FEAT
)

FEATURES[roadchain]=$(cat <<'FEAT'
Personal Chain Explorer --- Beautiful visual browser for your entire personal blockchain history
Proof Sharing Links --- One-click shareable links that let others verify without needing an account
Dispute Resolution Toolkit --- Built-in tools to settle disagreements using timestamped evidence
Carbon Impact Report --- Shows the environmental benefit of your carbon-negative anchoring
Selective Disclosure Builder --- ZK-style proofs for specific claims
Batch Anchor Scheduler --- Control anchoring frequency
Chain Health Dashboard --- Integrity and freshness overview
Re-Anchoring Tool --- Re-protect old records with newer crypto
Visual Proof Chain --- Animated tree of proof connections
Export Chain Manifest --- Full crypto history via OneWay
Community Verification --- Opt-in public proofs for open-source
Privacy Shield Layers --- Different visibility per record type
RoadCoin Staking for Anchoring --- Stake to support network
Long-Term Archive Mode --- Cold storage with extra redundancy
FEAT
)

FEATURES[roadcoin]=$(cat <<'FEAT'
Fuel Gauge Dashboard --- Real-time view of your RoadCoin balance and earning rate across all products
Spending Marketplace --- Browse and purchase premium compute, custom agents, boosted reach, or merch
Community Treasury Proposals --- Vote with staked RoadCoin on ecosystem improvements
Mileage Leaderboard --- Opt-in public or private ranking of top riders by total miles driven
Smart Fuel Advisor --- Personalized spending recommendations
Daily Fuel Bonus Calendar --- Visual streak and multiplier tracker
Spending Impact Simulator --- Preview purchase improvements
Community Treasury Proposals --- Vote with staked RoadCoin
Mileage Leaderboard --- Opt-in rankings with privacy controls
RoadCoin Bundles --- Discounted upgrade packs
Earning Pattern Analyzer --- Insights into best earning drivers
Charity Impact Mode --- Donate with matching and certificates
Staking Dashboard --- Yield, governance, lock-up visuals
RoadCoin History Road Map --- Earnings and spends timeline
Marketplace Search with Filters --- Find the upgrades you need
Referral Convoy Bonus --- Rewards for bringing new riders
Seasonal Limited Drops --- Themed items and bonuses
Legacy Fuel Archive --- Export full transaction history with proof
FEAT
)

FEATURES[roadworld]=$(cat <<'FEAT'
World Builder --- Create custom AI-powered game worlds with natural language
AI NPC Engine --- NPCs powered by RoadTrip agents with persistent memory
Multiplayer Convoy --- Play with friends and agents in shared worlds
RoadCoin Game Economy --- Earn and spend RoadCoin within game worlds
Terrain Generator --- Procedural world generation with AI-assisted design
Quest Architect --- Build narrative quests with branching storylines
Avatar Customizer --- Design characters with BlackBoard creative tools
Replay Theater --- Watch past game sessions with key moments highlighted
Cross-World Portals --- Travel between your worlds and community worlds
Asset Marketplace --- Buy and sell game assets with RoadCoin
Leaderboard System --- Rankings with RoadChain-verified achievements
Voice Command Play --- Control your character with natural voice
Learning Worlds --- Educational game modes powered by Roadie
World Export --- Save and share worlds via OneWay
FEAT
)

# ── All products for footer ──────────────────────────────────
ALL_PRODUCTS="os|BlackRoad OS|app
roadcode|RoadCode|roadcode
carpool|CarPool|chat
oneway|OneWay|oneway
roadside|RoadSide|roadside
roadview|RoadView|search
roadtrip|RoadTrip|roadtrip
backroad|BackRoad|social
roadwork|RoadWork|work
roadie|Roadie|tutor
blackboard|BlackBoard|blackboard
carkeys|CarKeys|carkeys
roadchain|RoadChain|chain
roadcoin|RoadCoin|coin
roadworld|RoadWorld|roadworld"

# ── Generate HTML for each product ───────────────────────────
for product_line in "${PRODUCTS[@]}"; do
  IFS='|' read -r slug name tagline subtitle color url subdomain stat1 stat2 stat3 stat4 <<< "$product_line"

  echo "Building $name ($subdomain.blackroad.io)..."

  PAGE_DIR="$OUT/$subdomain.blackroad.io"
  mkdir -p "$PAGE_DIR"

  # Build feature cards HTML
  FEATURE_HTML=""
  FEAT_NUM=0
  while IFS= read -r line; do
    [[ -z "$line" ]] && continue
    FEAT_NUM=$((FEAT_NUM + 1))
    feat_name="${line%% --- *}"
    feat_desc="${line#* --- }"
    FEATURE_HTML+="<div class=\"feature-card\" data-search=\"$(echo "$feat_name $feat_desc" | tr '[:upper:]' '[:lower:]')\">"
    FEATURE_HTML+="<span class=\"feat-num\">${FEAT_NUM}</span>"
    FEATURE_HTML+="<strong>$feat_name</strong>"
    FEATURE_HTML+="<p>$feat_desc</p>"
    FEATURE_HTML+="</div>"
  done <<< "${FEATURES[$slug]}"

  # Build connection cards
  CONN_HTML=""
  IFS='|' read -ra conns <<< "${CONNECTIONS[$slug]}"
  for conn in "${conns[@]}"; do
    CONN_HTML+="<div class=\"conn-card\"><p>$conn</p></div>"
  done

  # Build integration chips
  INTEG_HTML=""
  IFS='|' read -ra integs <<< "${INTEGRATIONS[$slug]}"
  for integ in "${integs[@]}"; do
    INTEG_HTML+="<span class=\"chip\">$integ</span>"
  done

  # Build footer links
  FOOTER_HTML=""
  while IFS= read -r fline; do
    [[ -z "$fline" ]] && continue
    IFS='|' read -r fslug fname fsub <<< "$fline"
    if [[ "$fslug" == "$slug" ]]; then
      FOOTER_HTML+="<a href=\"https://$fsub.blackroad.io\" class=\"footer-link active\">$fname</a>"
    else
      FOOTER_HTML+="<a href=\"https://$fsub.blackroad.io\" class=\"footer-link\">$fname</a>"
    fi
  done <<< "$ALL_PRODUCTS"

  # Write the HTML file
  cat > "$PAGE_DIR/index.html" <<HTMLEOF
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>$name — BlackRoad OS</title>
<meta name="description" content="$name: $subtitle. $tagline">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&family=Inter:wght@400;500&display=swap" rel="stylesheet">
<style>
:root {
  --g: linear-gradient(135deg, ${color}, ${color}88);
  --bg: #000;
  --card: #0a0a0a;
  --border: #1a1a1a;
  --text: #f5f5f5;
  --sub: #737373;
  --muted: #444;
  --accent: ${color};
}
*, *::before, *::after { margin: 0; padding: 0; box-sizing: border-box; }
body { background: var(--bg); color: var(--text); font-family: 'Inter', sans-serif; font-weight: 400; line-height: 1.6; -webkit-font-smoothing: antialiased; }
h1, h2, h3, h4, strong { font-family: 'Space Grotesk', sans-serif; color: var(--text); }
code, .mono { font-family: 'JetBrains Mono', monospace; }

/* Gradient bar */
.top-bar { position: fixed; top: 0; left: 0; right: 0; height: 3px; background: var(--g); z-index: 1000; }

/* Nav */
nav { position: fixed; top: 3px; left: 0; right: 0; background: rgba(0,0,0,0.92); backdrop-filter: blur(12px); border-bottom: 1px solid var(--border); padding: 0 2rem; height: 56px; display: flex; align-items: center; justify-content: space-between; z-index: 999; }
.nav-left { display: flex; align-items: center; gap: 12px; }
.nav-dot { width: 10px; height: 10px; border-radius: 50%; background: var(--accent); flex-shrink: 0; }
.nav-name { font-family: 'Space Grotesk', sans-serif; font-weight: 600; font-size: 1rem; color: var(--text); }
.nav-tag { font-family: 'JetBrains Mono', monospace; font-size: 0.65rem; color: var(--sub); letter-spacing: 0.1em; background: var(--card); border: 1px solid var(--border); padding: 2px 8px; border-radius: 4px; }
.nav-links { display: flex; align-items: center; gap: 1.5rem; }
.nav-links a { color: var(--sub); text-decoration: none; font-size: 0.85rem; transition: color 0.2s; }
.nav-links a:hover { color: var(--text); }
.nav-cta { background: var(--text); color: var(--bg); font-family: 'Space Grotesk', sans-serif; font-weight: 600; font-size: 0.8rem; padding: 6px 16px; border-radius: 6px; text-decoration: none; transition: opacity 0.2s; }
.nav-cta:hover { opacity: 0.85; }

/* Hero */
.hero { position: relative; padding: 10rem 2rem 5rem; text-align: center; overflow: hidden; }
.hero-bg { position: absolute; inset: 0; background-image:
  radial-gradient(circle at 30% 40%, ${color}18 0%, transparent 50%),
  radial-gradient(circle at 70% 60%, ${color}10 0%, transparent 50%);
  z-index: 0; }
.hero-grid { position: absolute; inset: 0; background-image: linear-gradient(var(--border) 1px, transparent 1px), linear-gradient(90deg, var(--border) 1px, transparent 1px); background-size: 60px 60px; opacity: 0.3; z-index: 0; }
.hero-content { position: relative; z-index: 1; max-width: 720px; margin: 0 auto; }
.badge { display: inline-flex; align-items: center; gap: 6px; font-family: 'JetBrains Mono', monospace; font-size: 0.7rem; color: var(--sub); border: 1px solid var(--border); padding: 4px 12px; border-radius: 20px; margin-bottom: 1.5rem; }
.badge-dot { width: 6px; height: 6px; border-radius: 50%; background: #22c55e; animation: pulse 2s infinite; }
@keyframes pulse { 0%, 100% { opacity: 1; } 50% { opacity: 0.4; } }
.hero h1 { font-size: clamp(2.2rem, 5vw, 3.5rem); font-weight: 700; line-height: 1.15; margin-bottom: 1rem; color: var(--text); }
.hero-sub { font-size: 1.1rem; color: var(--sub); max-width: 520px; margin: 0 auto 2.5rem; }
.hero-buttons { display: flex; gap: 12px; justify-content: center; flex-wrap: wrap; }
.btn-primary { background: var(--text); color: var(--bg); font-family: 'Space Grotesk', sans-serif; font-weight: 600; font-size: 0.9rem; padding: 10px 28px; border-radius: 6px; text-decoration: none; transition: opacity 0.2s; }
.btn-primary:hover { opacity: 0.85; }
.btn-secondary { background: transparent; color: var(--text); font-family: 'Space Grotesk', sans-serif; font-weight: 500; font-size: 0.9rem; padding: 10px 28px; border-radius: 6px; text-decoration: none; border: 1px solid var(--border); transition: border-color 0.2s; }
.btn-secondary:hover { border-color: #333; }

/* Stats strip */
.stats { display: grid; grid-template-columns: repeat(4, 1fr); max-width: 800px; margin: 0 auto; padding: 2rem; border-top: 1px solid var(--border); border-bottom: 1px solid var(--border); }
.stat { text-align: center; }
.stat-val { font-family: 'Space Grotesk', sans-serif; font-weight: 700; font-size: 1.3rem; color: var(--text); }
.stat-label { font-size: 0.75rem; color: var(--sub); margin-top: 4px; }

/* Sections */
section { padding: 5rem 2rem; max-width: 1100px; margin: 0 auto; }
section h2 { font-size: 1.8rem; font-weight: 700; margin-bottom: 0.5rem; color: var(--text); }
section .section-sub { color: var(--sub); margin-bottom: 2.5rem; font-size: 0.95rem; }

/* Feature filter */
.feature-filter { width: 100%; max-width: 400px; background: var(--card); border: 1px solid var(--border); color: var(--text); font-family: 'Inter', sans-serif; font-size: 0.9rem; padding: 10px 16px; border-radius: 6px; margin-bottom: 2rem; outline: none; transition: border-color 0.2s; }
.feature-filter:focus { border-color: #333; }
.feature-filter::placeholder { color: var(--muted); }

/* Feature grid */
.feature-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 16px; }
.feature-card { background: var(--card); border: 1px solid var(--border); border-radius: 10px; padding: 1.5rem; transition: border-color 0.2s; }
.feature-card:hover { border-color: #333; }
.feat-num { font-family: 'JetBrains Mono', monospace; font-size: 0.7rem; color: var(--muted); display: block; margin-bottom: 8px; }
.feature-card strong { font-size: 1rem; display: block; margin-bottom: 6px; color: var(--text); }
.feature-card p { font-size: 0.85rem; color: var(--sub); line-height: 1.5; }
.feature-card.hidden { display: none; }

/* The Ride */
.ride-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(240px, 1fr)); gap: 16px; }
.conn-card { background: var(--card); border: 1px solid var(--border); border-radius: 10px; padding: 1.25rem; position: relative; padding-left: 1.75rem; }
.conn-card::before { content: ''; position: absolute; left: 0; top: 1rem; bottom: 1rem; width: 3px; border-radius: 2px; background: var(--accent); }
.conn-card p { font-size: 0.9rem; color: var(--sub); }

/* Integrations */
.chip-grid { display: flex; flex-wrap: wrap; gap: 10px; }
.chip { background: var(--card); border: 1px solid var(--border); border-radius: 20px; padding: 6px 16px; font-family: 'JetBrains Mono', monospace; font-size: 0.75rem; color: var(--sub); transition: border-color 0.2s; }
.chip:hover { border-color: #333; }

/* Status indicator */
.status-bar { max-width: 1100px; margin: 0 auto; padding: 1rem 2rem; }
.status-pill { display: inline-flex; align-items: center; gap: 6px; font-family: 'JetBrains Mono', monospace; font-size: 0.7rem; color: var(--sub); border: 1px solid var(--border); padding: 4px 12px; border-radius: 20px; }
.status-dot { width: 6px; height: 6px; border-radius: 50%; background: var(--muted); }
.status-dot.live { background: #22c55e; }

/* Footer */
footer { border-top: 1px solid var(--border); padding: 3rem 2rem; margin-top: 3rem; }
.footer-inner { max-width: 1100px; margin: 0 auto; }
.footer-products { display: flex; flex-wrap: wrap; gap: 8px; margin-bottom: 2rem; }
.footer-link { font-family: 'JetBrains Mono', monospace; font-size: 0.72rem; color: var(--muted); text-decoration: none; padding: 4px 10px; border: 1px solid var(--border); border-radius: 4px; transition: all 0.2s; }
.footer-link:hover { color: var(--sub); border-color: #333; }
.footer-link.active { color: var(--sub); border-color: #333; }
.footer-copy { font-size: 0.75rem; color: var(--muted); }

/* Help modal */
.help-overlay { display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.8); z-index: 2000; align-items: center; justify-content: center; }
.help-overlay.show { display: flex; }
.help-box { background: var(--card); border: 1px solid var(--border); border-radius: 10px; padding: 2rem; max-width: 400px; width: 90%; }
.help-box h3 { margin-bottom: 1rem; color: var(--text); }
.help-row { display: flex; justify-content: space-between; padding: 6px 0; font-size: 0.85rem; }
.help-key { font-family: 'JetBrains Mono', monospace; color: var(--sub); background: var(--bg); padding: 2px 8px; border-radius: 4px; font-size: 0.75rem; }

/* Responsive */
@media (max-width: 640px) {
  .stats { grid-template-columns: repeat(2, 1fr); gap: 1rem; }
  .feature-grid { grid-template-columns: 1fr; }
  .nav-links { display: none; }
  .hero { padding: 8rem 1.5rem 3rem; }
}
</style>
</head>
<body>
<div class="top-bar"></div>

<nav>
  <div class="nav-left">
    <div class="nav-dot"></div>
    <span class="nav-name">$name</span>
    <span class="nav-tag">BLACKROAD OS</span>
  </div>
  <div class="nav-links">
    <a href="#features">Features</a>
    <a href="#ride">The Ride</a>
    <a href="#integrations">Integrations</a>
    <a href="$url" class="nav-cta">Open $name</a>
  </div>
</nav>

<div class="hero">
  <div class="hero-bg"></div>
  <div class="hero-grid"></div>
  <div class="hero-content">
    <div class="badge"><span class="badge-dot"></span><span id="status-text">CHECKING</span></div>
    <h1>$tagline</h1>
    <p class="hero-sub">$name — $subtitle. Part of the BlackRoad OS highway.</p>
    <div class="hero-buttons">
      <a href="$url" class="btn-primary">Open $name</a>
      <a href="https://app.blackroad.io" class="btn-secondary">The Highway</a>
    </div>
  </div>
</div>

<div class="stats">
  <div class="stat"><div class="stat-val">$stat1</div><div class="stat-label">Capability</div></div>
  <div class="stat"><div class="stat-val">$stat2</div><div class="stat-label">Depth</div></div>
  <div class="stat"><div class="stat-val">$stat3</div><div class="stat-label">Feature</div></div>
  <div class="stat"><div class="stat-val">$stat4</div><div class="stat-label">Foundation</div></div>
</div>

<div class="status-bar">
  <div class="status-pill"><span class="status-dot" id="health-dot"></span><span id="health-text">Checking health...</span></div>
</div>

<section id="features">
  <h2>Features</h2>
  <p class="section-sub">${FEAT_NUM} capabilities. All verified. All earning RoadCoin.</p>
  <input type="text" class="feature-filter" id="featureFilter" placeholder="Filter features...">
  <div class="feature-grid" id="featureGrid">
    $FEATURE_HTML
  </div>
</section>

<section id="ride">
  <h2>The Ride</h2>
  <p class="section-sub">How $name connects to the highway.</p>
  <div class="ride-grid">
    $CONN_HTML
  </div>
</section>

<section id="integrations">
  <h2>Integrations</h2>
  <p class="section-sub">Connected across the BlackRoad OS highway.</p>
  <div class="chip-grid">
    $INTEG_HTML
  </div>
</section>

<footer>
  <div class="footer-inner">
    <div class="footer-products">
      $FOOTER_HTML
    </div>
    <p class="footer-copy">BlackRoad OS, Inc. 2025-2026. Remember the Road. Pave Tomorrow.</p>
  </div>
</footer>

<div class="help-overlay" id="helpOverlay">
  <div class="help-box">
    <h3>Keyboard Shortcuts</h3>
    <div class="help-row"><span>Filter features</span><span class="help-key">/</span></div>
    <div class="help-row"><span>Clear filter</span><span class="help-key">Esc</span></div>
    <div class="help-row"><span>This help</span><span class="help-key">?</span></div>
    <div class="help-row"><span>Close</span><span class="help-key">Esc</span></div>
  </div>
</div>

<script>
(function() {
  // Health check
  var dot = document.getElementById('health-dot');
  var txt = document.getElementById('health-text');
  var stxt = document.getElementById('status-text');
  fetch('$url', { mode: 'no-cors', cache: 'no-store' }).then(function() {
    dot.classList.add('live');
    txt.textContent = '$subdomain.blackroad.io reachable';
    stxt.textContent = 'LIVE';
  }).catch(function() {
    txt.textContent = '$subdomain.blackroad.io unreachable';
    stxt.textContent = 'OFFLINE';
  });

  // Feature filter
  var filter = document.getElementById('featureFilter');
  var cards = document.querySelectorAll('.feature-card');
  filter.addEventListener('input', function() {
    var q = this.value.toLowerCase();
    cards.forEach(function(c) {
      var s = c.getAttribute('data-search') || '';
      c.classList.toggle('hidden', q.length > 0 && s.indexOf(q) === -1);
    });
  });

  // Keyboard shortcuts
  var help = document.getElementById('helpOverlay');
  document.addEventListener('keydown', function(e) {
    if (e.target.tagName === 'INPUT') {
      if (e.key === 'Escape') { filter.value = ''; filter.dispatchEvent(new Event('input')); filter.blur(); }
      return;
    }
    if (e.key === '?') { help.classList.toggle('show'); }
    else if (e.key === '/') { e.preventDefault(); filter.focus(); }
    else if (e.key === 'Escape') { help.classList.remove('show'); }
  });
  help.addEventListener('click', function(e) { if (e.target === help) help.classList.remove('show'); });
})();
</script>
</body>
</html>
HTMLEOF

  echo "  -> $PAGE_DIR/index.html ($FEAT_NUM features)"
done

echo ""
echo "All 15 product pages generated in $OUT"
echo ""

# ── Deploy to Gematria ────────────────────────────────────────
echo "Deploying to Gematria..."

for product_line in "${PRODUCTS[@]}"; do
  IFS='|' read -r slug name tagline subtitle color url subdomain _ <<< "$product_line"
  echo "  Deploying $subdomain.blackroad.io..."
  ssh root@gematria "mkdir -p /var/www/$subdomain.blackroad.io" 2>/dev/null
  scp -q "$OUT/$subdomain.blackroad.io/index.html" "root@gematria:/var/www/$subdomain.blackroad.io/index.html"
done

echo ""
echo "Reloading Caddy..."
ssh root@gematria "systemctl reload caddy"

echo ""
echo "Done. 15 product pages deployed to Gematria."
echo "  Pages: app, roadcode, chat, oneway, roadside, search, roadtrip, social, work, tutor, blackboard, carkeys, chain, coin, roadworld"
