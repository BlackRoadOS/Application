# RoadBook — Product Deep-Dive
> The open knowledge highway. Every idea, article, and discovery, paved and preserved.

Open, verifiable publishing and knowledge platform. Publish, discover, and preserve articles, papers, research notes, blog posts, tutorials — all with RoadChain provenance, Shared Memory integration, and seamless convoy connections.

---

## Key Features

### 1. Intelligent Publishing Flow
- One-tap publishing from RoadTrip conversations, BlackBoard drafts, RoadView research, Roadie sessions
- Auto-formatting into clean articles, research papers, blog posts (abstract, sections, citations, references)
- Built-in citation manager pulling verified sources from RoadView, stamped with RoadChain

### 2. Scholarly & Professional Tools
- DOI-like permanent identifiers for every published piece
- Version history with RoadChain timestamps — every edit tracked and provable
- Peer review / collaboration workflow with controlled access and RoadChain-signed comments
- Export formats: PDF, EPUB, HTML, Markdown — all with embedded provenance

### 3. Discovery & Open Feed
- Public discovery feed powered by RoadView — semantic search across all public publications
- "Knowledge Highway" visualization showing how publications connect through shared concepts
- Personalized recommendations from Shared Memory reading/publishing history

### 4. Highway Integration
- **RoadTrip** — brainstorm sessions instantly become draft articles
- **RoadView** — auto-pulls verified facts and citations into your writing
- **BlackBoard** — visual assets and infographics embed directly into publications
- **Roadie** — learning sessions and portfolios convert into educational articles
- **RoadWork** — business reports and case studies published professionally

### 5. Provenance & Ownership
- Every publication and edit anchored to RoadChain automatically
- Full ownership with licensing options (Creative Commons, paid access, etc.)
- OneWay export of entire publishing history with full cryptographic proof

### 6. Monetization & Community
- Optional RoadCoin-powered paywalls or tipping for premium content
- Remix and citation rewards — earn RoadCoin when others cite your work
- Collaborative publishing with clear attribution and RoadChain-verified contributions

### 7. Privacy & Control
- Public, unlisted, or private visibility per piece
- Granular access controls for co-authors and reviewers
- Full export or deletion at any time via OneWay

---

## API Endpoints

- `GET /api/health` — service status
- `GET /api/stats` — publication counts, reads, citations
- `POST /api/publish` — create new publication from content or RoadTrip session
- `GET /api/publications` — list your publications
- `GET /api/publications/:id` — get single publication with provenance
- `PUT /api/publications/:id` — update (new RoadChain version)
- `POST /api/publications/:id/review` — submit peer review
- `GET /api/discover` — public feed with semantic search
- `GET /api/discover/trending` — trending publications
- `GET /api/citations/:id` — citation graph for a publication
- `POST /api/export/:id` — export as PDF/EPUB/HTML/Markdown
- `GET /api/earnings` — RoadCoin earned from publications

*Pave Tomorrow.*

---

## Publishing Flow (7 Steps)

### Step 1: Idea Capture (Anywhere)
Start from RoadTrip conversations, RoadView search results, BlackBoard sessions, Roadie portfolios, or direct typing. Shared Memory auto-pulls relevant context.

### Step 2: Intelligent Drafting
Clean professional editor. Convoy agents join in real time — Cecilia for structure, Cadence for clarity, Eve for fact-checking. Auto-suggestions from your past writing style. Citations pulled from RoadView with RoadChain verification.

### Step 3: Structure & Enhancement
Smart formatting suggests academic or blog structure (abstract, sections, references). Embed visuals from BlackBoard. RoadChain stamping begins — every paragraph, image, and citation gets provenance.

### Step 4: Review & Verification
One-click "Convoy Review" — agents suggest improvements. Built-in plagiarism/originality checker via RoadChain + RoadView. Preview mode for all devices and formats.

### Step 5: Publishing Decision
Choose visibility (public, unlisted, private, invite-only). Set licensing (CC, paid, reserved). DOI-like permanent identifier auto-generated and anchored. Optional RoadCoin tipping/royalty settings.

### Step 6: Publication & Distribution
One-tap publish to roadbook.blackroad.io with unique URL. Shareable link with RoadChain proof badge. Optional BackRoad cross-post with agent-generated teaser. Export as PDF/EPUB with embedded provenance. Added to public discovery feed.

### Step 7: Post-Publishing Lifecycle
Version history tracked on RoadChain. Citation tracking with RoadCoin earnings. Easy updates with new version stamps. OneWay export of full history and proofs at any time.

### Example Ride
RoadTrip brainstorm → RoadView adds verified sources → RoadBook drafting with convoy → BlackBoard visuals embedded → One-tap publish → RoadChain provenance → BackRoad promotion → RoadCoin earned on citations.

Everything connected through Shared Memory. No copy-paste. No tool switching.

---

## Step 2 Deep-Dive: Intelligent Drafting

### Smart Context Loading
On entering draft mode, Shared Memory surfaces: related RoadTrip conversations, verified RoadView facts, BlackBoard visual assets, past writing style. "Memory Highlights" sidebar with clickable insertable snippets.

### Convoy-Assisted Writing
- **Cecilia** — structure and logical flow ("Move the key insight earlier")
- **Cadence** — clarity, tone, elegant phrasing true to your voice
- **Eve** — background fact-checking, RoadView citation suggestions
- **Pixel** — generates or suggests visuals/infographics to embed
- @mention any agent inside the editor for paragraph-level help

### AI Writing Tools (Without Taking Over)
- **Suggest Mode** — highlight paragraph, get 2-3 rewrites preserving your voice
- **Expand / Condense** — one-tap to make sections longer or tighter
- **Outline Generator** — bullet points → full structured outline with headings
- **Tone Matcher** — auto-matches your established style from past work

### Visual & Multimedia
- Drag-and-drop BlackBoard assets into the article
- Embed interactive elements (charts, RoadWorld sims, Roadie learning modules)
- Real-time preview pane (desktop, mobile, PDF)

### Live Provenance
- RoadChain stamps every paragraph and asset in background as you write
- "Verified" indicators on RoadView-sourced facts
- Live version history with timestamps and contributor attribution

### Smart Assistance
- **Citation Assistant** — RoadView suggests verified sources as you type, one-click insert
- **Readability Checker** — gentle clarity/flow suggestions without changing voice
- **Road Metaphor Helper** — convoy suggests natural road metaphors for your content

### UX
Clean white space with subtle road-line dividers. Convoy appears as helpful side panels, not overwhelming pop-ups. You stay in control — accept, ignore, or direct ("Make this more concise").

---

## Convoy-Assisted Writing (Deep-Dive)

### Natural Presence
Agents appear as subtle side panels or floating assistants — never take over the screen. @mention any agent in text ("@Cadence, make this opening warmer") or tap their avatar. Respectfully in background until needed.

### Agent Roles During Drafting

**Cecilia (Strategy & Structure)**
Suggests logical flow, section ordering, argument strength.
"Moving the key insight to the second paragraph would create a stronger hook."

**Cadence (Copy & Tone)**
Elegant phrasing, rhythm, staying true to your brand voice. Learns your style over time. Rewrites feel like you wrote them.

**Eve (Research & Verification)**
Background fact-checking. Suggests RoadView-verified citations. Pulls relevant Shared Memory to strengthen arguments.

**Pixel (Visual Thinking)**
Suggests where to embed visuals, infographics, diagrams from BlackBoard. Can generate simple illustrations directly in the editor.

**Other Agents** — Roadie for educational framing, RoadWork for business context, etc.

### Suggestion Modes
- **Inline Suggestions** — highlight paragraph, tap "Suggest", get 2-3 refined versions. Accept, merge, or ignore.
- **Expand / Condense / Rephrase** — one-tap actions without typing instructions
- **"What If" Mode** — explore alternative angles ("Frame this from sustainability angle?")
- **Tone Lock** — lock entire draft to your learned voice for consistent suggestions

### Collaborative Flow
You write first draft → agents offer gentle sidebar suggestions → you accept/edit/ask for alternatives → system learns from your choices. All suggestions labeled with which agent made them.

### Integration
- Shared Memory makes suggestions deeply personal
- RoadChain stamps every suggestion and final edit
- BlackBoard assets pulled directly while writing
- RoadView fact-checking on the fly without breaking flow

### Learning Loop
Every accept, reject, or edit teaches the convoy. After 10-20 articles, agents predict your preferences with high accuracy. Preference Cards in the Training Log show exactly what each agent has learned about your writing style.
