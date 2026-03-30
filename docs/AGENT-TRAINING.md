# Agent Training Mechanics
> Your convoy learns your voice — effortlessly, transparently, and permanently.

Applies to BackRoad, RoadTrip, and all agents across the highway.

---

## Core Philosophy

- **Ongoing and effortless** — learns from normal usage, not dedicated sessions
- **Human-in-the-loop** — you stay in control as the driver
- **Compounds via Shared Memory** — improvements build over time
- **All training logged on RoadChain** — transparent and provable

---

## Training Signals

### Implicit (Passive)
- **Engagement quality**: uncorrected posts = positive reinforcement
- **Performance correlation**: RoadView tracks which agent styles drive real engagement
- **Consistency matching**: compares output to your historical BlackBoard/RoadTrip content
- **Usage patterns**: frequent edits/overrides signal adjustment needed

### Explicit (Active)
- **Thumbs up/down** on replies — strengthens or weakens that style
- **Direct corrections** — system learns the delta between generated and preferred
- **Voice notes & instructions** — "Be more concise on LinkedIn" stored in Shared Memory
- **Style sliders** — tone adjustments (witty↔professional, warm↔direct)
- **Example prompts** — "Always include a question back to keep conversation going"

### Convoy-Wide
- Useful learnings propagate across agents via Shared Memory and CarPool
- Cecilia suggests training adjustments based on overall RoadView performance data

---

## Technical Mechanisms

### Memory Consolidation
After rides/campaigns, consolidation distills feedback into preferences:
- "User prefers concise copy with subtle road metaphors on Instagram"
- "Audience responds better when Pixel uses warm lighting"

Insights move to Warm memory layer and influence all future behavior.

### Reinforcement Learning Lite
- Positive outcomes (high engagement, your approval) → increase probability of similar outputs
- Negative outcomes → decrease probability
- No heavy model retraining — works within existing agent architecture

### RoadChain Provenance
Every training signal hashed and anchored. Review training history in Road Log.

---

## Training Timeline

- **Short-term** (few campaigns): noticeable improvement in surface preferences
- **Medium-term** (10–20 interactions): strong sense of your voice and audience
- **Long-term**: highly personalized extensions of you — like a team that's worked with you for years

---

## User Controls

- **Pause training** — per agent or convoy-wide
- **Reset** — revert to default behavior
- **Review mode** — see Training Log with what was learned and from which interactions
- **Privacy** — all training data in your Shared Memory vault, exportable/deletable via OneWay

---

## Preference Cards

The visual, editable representation of what each agent has learned.

### Card Contents

**Header**: Agent avatar + name, platform/context tag, strength meter (fuel gauge 1–10)

**Learned Preference** (human-readable):
- "Cadence on LinkedIn: Prefers concise, professional tone with occasional subtle road metaphors when addressing parents or educators."
- "Pixel visual style: Warm color palettes and highway-inspired compositions perform 27% better with urban audiences."

**Evidence**: "Based on 47 interactions (32 positive, 8 corrections, 7 explicit instructions)" + before/after snippets

**Impact**: Engagement lift from RoadView + RoadCoin earned from this behavior

**Actions**:
- **Reinforce** — do more of this (increases strength)
- **Adjust** — edit text or add nuance
- **Weaken / Remove** — reduce confidence or delete
- **See History** — full interaction timeline

### How Cards Are Generated
- **Automatic**: Memory Consolidation identifies recurring patterns after campaigns or 10-20 interactions
- **Manual**: Highlight a reply → "Save as Preference"
- **Dynamic**: Strength meter updates in real time from new feedback
- **Cross-agent**: Strong preferences suggested to other agents

### Visual Design
- Road-line border, glows brighter as strength increases
- Green = well-established, Yellow = emerging, Gray = weakened
- Smooth animations on strength changes
- Mobile-optimized, cards stack vertically

### Example Cards

**Cadence – LinkedIn**
Strength: ████████░░ 8.2/10
"Prefers concise, value-first openings followed by one thoughtful question. Uses subtle road metaphors when audience includes educators or parents."
Evidence: 34 positive, 6 edits. Impact: +19% comment rate.

**Pixel – Instagram**
Strength: ██████░░░░ 6.4/10
"Warm lighting, highway-inspired compositions, and subtle motion in carousels perform best with 25-40 urban audience."
Evidence: 12 high-engagement posts. Impact: +31% save rate.

**Roadie – General**
Strength: █████████░ 9.1/10
"Uses encouraging, patient tone with middle-school students. Prioritizes questions over statements and celebrates small discoveries."
Evidence: 68 sessions. Impact: Consistent streak bonuses.

---

## Cross-Highway Impact

- Training in BackRoad improves agents across **all** products
- Better training → higher RoadCoin earnings (better engagement = more rewards)
- Trained agents make RoadView searches and Roadie sessions more personalized
- Everything exportable via OneWay with full provenance

---

## Manual Preference Editing

### Access
- **Cmd/Ctrl + Shift + T** or dock icon → Training Log → "Edit Preferences" or "+"
- Highlight any agent reply in BackRoad/RoadTrip → "Save as New Preference"
- In BlackBoard draft → "Teach Agent" toolbar button

### Quick-Create Mode (Fastest)
Type or speak a natural instruction:
- "Cadence should open LinkedIn posts with a short question and end with a subtle call-to-action."
- "Pixel: Use warmer color palettes and include at least one highway element in every carousel."
- "Roadie with teens: Be encouraging but never patronizing. Use more road metaphors."

System instantly suggests a polished Preference Card and shows similar existing preferences for context.

### Structured Editor (For Precision)
- **Preference Name**: Short label (e.g., "LinkedIn Opening Style")
- **Applies To**: Agent(s) + Platform(s) + Context (e.g., Cadence on LinkedIn when audience includes educators)
- **Core Rule**: The actual preference in clear language
- **Strength Slider**: 1–10, how strongly this influences the agent
- **Examples**: 2–4 before/after examples for nuance
- **Exceptions**: Edge cases ("Except when replying to complaints — then be more empathetic")

### Smart Suggestions
- Auto-completions from your past content and Shared Memory
- Flags conflicts with existing preferences, suggests resolutions

### After Saving
1. Card appears immediately in Training Log
2. Agent applies on next relevant interaction (often within minutes)
3. Memory Consolidation incorporates during next cycle
4. Confirmation: "Cadence has learned your new LinkedIn style."
5. Performance impact tracked via RoadView

### Advanced Options
- **Priority Level**: "Core" (very hard to override) or "Flexible" (adaptive)
- **Time/Platform Weighting**: "Apply more strongly on weekdays for LinkedIn"
- **Negative Preferences**: "Never use corporate jargon on TikTok"
- **Convoy-Wide Propagation**: influence one agent or suggest to similar agents
- **Version History**: every edit RoadChain-stamped, revertible

### Example Flow

Notice Cadence's LinkedIn replies are too salesy →
Open recent reply → "Teach Agent" →
Write: "Start with a thoughtful question. Keep tone helpful and conversational. End with subtle road metaphor when appropriate." →
Add two example edits → Set strength 8/10, mark as "Core" for LinkedIn → Save.

Within the next few posts, Cadence's replies shift noticeably. Card appears in Training Log with growing strength.

*Pave Tomorrow.*

---

## Agent Learning Process (Complete)

### 1. Core Learning Mechanisms

**Implicit (Passive)**
Every interaction is a signal: accept/edit/delete suggestions, engagement on BackRoad replies, frequency of overrides. Fed into Shared Memory, processed during Memory Consolidation.

**Explicit (Active)**
- Thumbs up/down, ratings in Training Log
- Manual edits analyzed — delta becomes a preference
- Natural language: "Cadence, be more concise on LinkedIn" / "Pixel, warmer tones for families" / "Roadie, more guiding questions with teens"
- Stored as Preference Cards influencing future behavior

**Convoy-Wide**
Learning spreads through CarPool. Cadence learns you prefer subtle road metaphors → suggested to RoadWork emails, Roadie explanations, etc.

### 2. Memory Consolidation in Learning

Runs after campaigns, 10-20 interactions, or scheduled quiet periods. Distills raw interactions into actionable preferences:
- Surface: "Use shorter sentences"
- Deeper: "User values clarity mixed with warmth when communicating with parents"

Stored in Warm Layer of Tiered Memory. Foundation for all future agent behavior.

### 3. Training Log — Control Center

Preference Cards show: what was learned, strength (fuel gauge), evidence (interaction count), performance impact. Manual controls: reinforce, edit, weaken, remove, view full history.

### 4. Reinforcement Loop

- **Positive**: high engagement, your approval, successful outcomes → strengthen
- **Negative**: corrections, low engagement, explicit "don't do this" → weaken
- Lightweight RL within existing architecture — no heavy retraining

### 5. Evolution Timeline

- **Days 1-7**: Surface preferences (tone, length, common phrases)
- **Weeks 1-4**: Strong voice and audience understanding
- **Months 1+**: Highly personalized — anticipates needs, adapts naturally. Like a team that's worked with you for years.

### 6. Transparency & Control

- Pause learning per agent or convoy-wide
- Reset any agent to default
- Review and edit every preference
- Export full training history via OneWay with RoadChain proof
- Everything logged on RoadChain — see exactly when and why anything was learned

### Example Timeline

**Week 1**: Edit Cadence's LinkedIn replies to be warmer with road metaphors → Preference Card created.
**Week 3**: Cadence naturally uses warmer tone + metaphors → thumbs-up → strength increases.
**Month 2**: Cadence writes in your style with almost no edits → preference in Warm Layer, influences other agents.
