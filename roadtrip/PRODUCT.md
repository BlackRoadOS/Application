# RoadTrip — Product Deep-Dive
> Pick up your passengers. They never forget the ride.

Persistent, lively group chat where your convoy of 18 specialized AI agents rides together — sharing long-term memory, collaborating in real time, debating ideas, handing off tasks, and remembering every detail about you and every previous mile.

---

## Core Features

### 1. Always-On Group Chat with Named Agents
- 18 distinct agents with unique personalities: Cecilia (strategy), Eve (research), Pixel (design), Cadence (copy), Math Maverick, Science Scout, and more
- Real-time group chat with @mentions, threaded replies, natural conversation flow
- "Passenger Spotlight" mode: focus convoy on one agent for deep work, others ready in background

### 2. Shared Long-Term Memory Engine
- Persistent memory that survives tabs, devices, sessions, and OneWay exports
- Automatic memory consolidation: agents summarize, connect dots, organize into living "Road Log"
- Visual road-map timeline showing who contributed what and how ideas evolved
- Memory export/import: bring old RoadTrips forward or share via RoadChain-verified links

### 3. Voice-First & Hands-Free
- Full voice conversation for in-car, walking, bedtime rides — convoy listens, speaks, celebrates
- Smart interruption handling: agents wait turns, jump in only when relevant
- "Convoy Radio" background mode while working in other products

### 4. Trigger-Based Collaboration
- Natural-language triggers: "When Eve finishes research, hand to Pixel for visuals and Cadence for copy"
- Workflow templates: content campaign, lesson plan, business pitch, code review
- Agent-to-agent hand-offs with approval gates and RoadChain decision logs
- Multi-product mode: pull RoadView facts or BlackBoard visuals mid-session

### 5. Topic Threads & Organization
- Auto-organizing by project, trip, or theme — never lose context
- "Memory Milestones": breakthroughs trigger group celebration + RoadCoin bonus
- Animated road signs, fuel-gauge progress bars, real-time convoy avatars

### 6. RoadChain & RoadCoin
- Every message, hand-off, decision, memory update hashed and anchored
- Earn RoadCoin for meaningful contributions
- Shareable "Convoy Highlights" with verifiable provenance

### 7. Privacy & Control
- You are always the driver: mute, remove, set quiet mode
- Granular permissions per agent per memory category
- Full OneWay export of entire RoadTrip history

---

## Memory Engine (Deep-Dive)

### Persistent Cross-Session Storage
Every meaningful piece stored durably — never resets on tab close or device switch:
- Raw conversation history
- Extracted facts and insights
- User preferences and working style
- Project context and decisions
- Learned patterns ("You prefer concise copy with road metaphors")

### Tiered Architecture
- **Hot Layer**: recent conversations, active projects, frequently used facts. Always loaded, lightning-fast.
- **Warm Layer**: consolidated insights, connected ideas, medium-term patterns. Built during consolidation cycles.
- **Cold Layer**: full raw history, older memories. Searchable, stored efficiently.

### Intelligent Consolidation
Runs automatically after major sessions or on schedule:
- Summarizes long threads into crisp insights
- Merges similar memories into stronger fact nodes
- Builds relationship graphs ("pricing discussion links to RoadWork invoice template")
- Extracts and reinforces user preferences
- Review, edit, approve consolidation previews in Training Log

### Semantic Retrieval
- Intelligent semantic search across all three layers
- Relevant memories auto-injected with attribution and timestamps
- Prioritizes freshness and relevance — no old noise overwhelming agents

### User Control
- **Road Log**: visual timeline of memory creation, consolidation, connections
- Browse, edit, protect, prune any memory
- "Forget This Ride" — selectively archive threads while keeping key insights
- Full OneWay export with cryptographic proof

### Cross-Product Flow
Memory shared across the entire highway:
- RoadTrip conversations feed RoadView searches and BlackBoard creation
- Roadie sessions strengthen RoadBook publications
- RoadWork decisions become long-term knowledge
- All agents (native + imported) read from and contribute to same vault via CarPool

### RoadChain Provenance
Every memory creation, update, consolidation step hashed and anchored. Prove exactly when a memory was formed and how it evolved.

---

## How RoadTrip Powers The BlackRoad

RoadTrip is the lively back seat that makes every ride feel alive. It turns solo AIs into a collaborative team that remembers everything, works together, and grows with you. Whether building with RoadWork, creating on BlackBoard, learning with Roadie, or just brainstorming — the convoy is always there, sharp, supportive, and never forgetting a single mile.

*Pave Tomorrow.*

---

## Tiered Memory Architecture (Expanded)

### Hot Layer — Active, Instant Recall
- Recent messages, active projects, core preferences, high-confidence RoadView facts
- Sub-second retrieval via in-memory + fast cache
- Deliberately lean — low-relevance items auto-demoted during consolidation
- Strongly guarded, rarely pruned unless explicitly allowed

### Warm Layer — Consolidated Wisdom
- Summarized insights from consolidation cycles
- Relationship graphs ("pricing discussion links to RoadWork invoice template")
- Medium-term patterns and learned behaviors ("prefers concise copy with road metaphors on LinkedIn")
- Auto-populated during consolidation. Manually promotable/demotable.

### Cold Layer — Complete Archive
- Raw chat logs, older memories, audit trails, selectively archived items
- Seconds to retrieve. Agents query Cold only when Hot+Warm don't have the answer.
- Fully searchable via semantic queries. Browsable in Road Log.
- Complete OneWay export with all tiers.

### Dynamic Movement
- Frequently referenced → promoted to Hot
- Valuable but rare → stays Warm
- Low-signal/outdated → settles to Cold
- Every tier movement logged on RoadChain

### Road Log Interface
- Hot = bright active road lines, Warm = steady highway, Cold = archived side roads
- One-click promote, demote, protect, hard-delete
- Search across all tiers with layer labels on results

---

## Memory Consolidation Process (Expanded)

### Triggers
- **Automatic**: after milestones, scheduled quiet periods, size thresholds
- **Manual**: force from Training Log or Road Log anytime

### The Pipeline

**Step A: Summarization**
Long/repetitive threads condensed into high-signal summaries. Three depths:
- **Micro-Summary**: single sentence ("Decided on tiered pricing with road-metaphor branding")
- **Mid-Level**: structured bullet points with decisions, action items
- **Context-Rich**: includes nuances, preferences, connections to past rides (stored in Warm)

Agent collaboration: Cecilia (structure), Cadence (language), Eve (fact-check), Roadie (educational framing). Consensus before finalizing.

Quality checks: preserves meaning, maintains tone, includes decisions, removes redundancy. Low-quality flagged for review.

**Step B: Merging Similar Memories**
Multiple conversations on same topic merged into single stronger fact node with reinforced confidence.

**Step C: Relationship Graphs**
Links related memories across products: "pricing discussion from RoadTrip → invoice template in RoadWork → customer feedback in RoadView"

**Step D: Preference Extraction**
Identifies behavioral patterns: "User prefers concise copy with subtle road metaphors when addressing parents or educators"

**Step E: Selective Decay**
Low-relevance details deprioritized or moved to Cold. Never truly deleted unless you choose. Keeps active memory sharp.

**Step F: Reflective Integration**
Agents generate higher-level insights: "You consistently value clarity mixed with warmth for family audiences"

### After Consolidation
- High-value insights → Hot Layer
- Summarized knowledge → Warm Layer
- Raw data → Cold Layer

### User Control
- **Consolidation Preview**: transparent before/after in Training Log
- Approve, edit, reject proposed changes
- Full history on RoadChain with timestamps and comparisons

### Real Example
3-month marketing campaign → hundreds of raw messages → system distills into "Campaign Strategy Summary" node → extracts key preferences → raw logs to Cold, summary to Warm → you review, make one edit, approve → convoy immediately sharper for next campaign.

---

## Agent-Assisted Summarization (Deep-Dive)

### Trigger & Candidate Selection
System identifies threads needing summarization (long, completed, repeated, high-value). Assembles temporary "Summarization Convoy" — most relevant agents for that thread.

### Multi-Agent Collaboration
Agents collaborate in a mini session specifically for summarization:

- **Cecilia** leads: analyzes thread, proposes structure (chronological, thematic, decision-focused)
- **Cadence** refines: natural language, concise, consistent with your voice, removes filler
- **Eve** verifies: cross-checks facts against RoadView and Shared Memory, adds citations
- **Roadie** (educational threads): ensures clarity, suggests simplifications
- Others join as needed (Pixel for visual summaries, RoadWork agents for business context)

### Iterative Refinement
Agents generate drafts at three depths (micro, mid-level, context-rich). Review each other's drafts, debate improvements, reach consensus. Final set presented in Training Log as "Before & After" preview.

### User Approval
See original thread alongside proposed summaries. Options:
- Approve as-is
- Edit directly
- Request different emphasis ("more concise" / "focus on pricing decision")
- Reject and request re-summarization
- Feedback immediately learned for future quality

### Memory Integration
On approval: micro → Hot Layer, mid-level + context-rich → Warm Layer, raw conversation → Cold Layer. All stamped with RoadChain provenance including which agents contributed.

### Example: Marketing Campaign (87 messages, 3 days)
Cecilia proposes decision-focused structure → Cadence matches warm professional tone → Eve verifies audience data with RoadView citations → agents debate and produce three drafts → you tweak one sentence, approve.

Results:
- Micro: "Finalized tiered pricing with 'Easy Drive' branding for urban parents; assets ready for BackRoad launch."
- Mid: key decisions, action items, timeline
- Context-rich: road metaphor preference + lessons from previous campaign

Convoy updates Shared Memory. Future agents noticeably smarter on similar campaigns.
