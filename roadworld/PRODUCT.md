# RoadWorld — Product Deep-Dive
> Build the world. Play the road.

Powerful, accessible game engine and creative playground. Roblox-style creation + Cities: Skylines depth + open-world freedom — all wrapped in the road/highway metaphor. Drag-and-drop to build worlds, create games, run simulations. Convoy agents help as co-creators, NPCs, and playtesters.

---

## Core Vision

- **Drag-and-Drop Creation**: Intuitive building — place roads, buildings, vehicles, characters with simple gestures
- **Hybrid Scale**: Small pixel scenes to massive 3D open worlds
- **Genre Mashup**: Roblox creativity + Cities: Skylines + open-world + educational simulation

---

## Key Features

### 1. Massive Open-World Building
- Build cities, highways, countries, fantasy worlds on infinite grid
- Road-themed blocks: highways, intersections, rest stops, billboards, convoys, tunnels, bridges
- Seamless zoom from street level to continent scale

### 2. Drag-and-Drop Game Creation
- No-code / low-code: drag objects, connect logic with visual "road line" connectors
- Pre-built templates: City Builder, Life Simulator, Open-World Adventure, Pixel City, Educational Sims
- Instant build-to-play mode switching

### 3. Convoy as Co-Creators & NPCs
- Pixel helps with visuals and styling
- Cadence writes dialogue and quest lines
- Cecilia suggests gameplay balance
- Roadie turns areas into educational zones
- Agents act as NPCs — walking, giving quests, teaching, reacting with animations

### 4. BlackRoad Integration
- Import assets from BlackBoard (images, 3D models, videos)
- Pull live data from RoadView, RoadWork, RoadTrip for dynamic games
- Publish to BackRoad with RoadChain provenance
- Learning progress feeds back into Roadie mastery

### 5. Multiplayer & Social
- Invite friends/family to build and play in shared worlds
- "Convoy Mode" — agents from different users interact in same game
- Collaborative real-time building sessions

### 6. Economy & Rewards
- Earn RoadCoin by playing, creating, publishing
- In-game economy: fuel earned by completing challenges
- Creator revenue share when others play or remix your games

### 7. Educational & Simulation
- Real learning as interactive experiences (city management = economics, traffic sim = physics)
- Roadie auto-inserts Socratic teaching moments inside games

---

## Drag-and-Drop Mechanics

### Philosophy
- Zero friction — pick up, place, connect. Like LEGO on an infinite highway.
- Smart assistance — convoy suggests, auto-aligns, prevents mistakes
- Scalable depth — start simple, unlock advanced features as you grow

### Basic Object Placement
Drag from library onto world:
- **Roads**: straight, curves, intersections, highways, tunnels, bridges
- **Buildings**: houses, offices, shops, landmarks
- **Vehicles & Characters**: cars, trucks, agent avatars, NPCs
- **Nature**: trees, parks, rivers, mountains
- **Interactive**: billboards, traffic lights, quest markers

Smart grid snapping with glowing alignment guides. "Highway Flow" mode auto-curves roads. Hold Shift for free placement.

### Logic & Behavior Connections
Connect objects with visual "Road Lines" (glowing colored lines):
- Traffic light → road = controls traffic flow
- Quest marker → character = NPC with dialogue
- Roadie quiz → building = educational challenge on entry

Convoy helps: Pixel suggests visual connections, Cecilia recommends logical ones, Roadie adds learning triggers.

### Property Editing
Click any object for floating panel:
- **Visuals**: drag textures, colors, models
- **Behavior**: drag logic chips (Move, Animate, Give Quest, Teach Concept)
- **Data Links**: drag live BlackRoad data (RoadCoin, RoadView facts, RoadWork metrics)

### Convoy-Assisted Building
- Pixel suggests better placements and color schemes
- Cadence offers naming and dialogue suggestions
- Cecilia warns about balance ("This intersection might cause traffic jams")
- Drag agent characters directly onto the world as NPCs

### Multi-Layer Building
- **Base Layer**: terrain and roads
- **Object Layer**: buildings and props
- **Logic Layer**: invisible connections and behaviors
- **Overlay Layer**: UI, quest markers, educational pop-ups
- Toggle layers on/off while building

### Advanced Features
- **Script Mode**: visual scripts or simple code for advanced users
- **Physics & Simulation**: drag physics properties (gravity, traffic rules, weather) onto areas
- **Multiplayer Building**: friends drag objects in same world simultaneously
- **Undo/Redo Highway**: timeline scrubber with RoadChain version history

---

## API Endpoints

- `GET /api/health` — service status
- `GET /api/stats` — worlds created, players, games published
- `POST /api/worlds` — create new world
- `GET /api/worlds` — list your worlds
- `GET /api/worlds/:id` — get world with state
- `PUT /api/worlds/:id` — save world state
- `POST /api/worlds/:id/publish` — publish as playable game
- `GET /api/discover` — public game discovery feed
- `GET /api/discover/trending` — trending games
- `POST /api/worlds/:id/play` — start play session
- `GET /api/templates` — pre-built game templates
- `POST /api/worlds/:id/invite` — invite collaborators
- `GET /api/earnings` — RoadCoin earned from games

---

## Technical Notes

- Renders via WebGL/Canvas in browser — no downloads
- Asset pipeline from BlackBoard (images, models) via Shared Memory
- World state persisted in D1 with RoadChain versioning
- Multiplayer via WebSocket rooms
- Mobile: simplified touch controls with same drag-and-drop
- Agent NPCs powered by RoadTrip conversation engine

*Pave Tomorrow.*

---

## Agent-Assisted Building Examples

### Racing Game Track
You drag road pieces → Pixel adds elevation and billboards → Cecilia suggests a chicane for strategy → Cadence writes checkpoint announcements ("Nice drifting! 50 RoadCoin!") → Roadie offers a fractions quiz at the final checkpoint. Core track becomes a rich experience in seconds.

### Educational City Simulator
You place buildings and roads → Pixel groups houses near parks for livability → Cecilia warns about traffic bottlenecks, suggests roundabout → Roadie adds environmental impact popup near the factory → Cadence writes mayor announcements. Agents walk around testing traffic flow while you build.

### Open-World Adventure
You lay a scenic highway → Pixel scatters roadside attractions and hidden viewpoints → Cecilia places a fork-in-the-road decision point → Cadence writes NPC dialogue ("Welcome traveler! Got any RoadCoin for a story?") → Roadie designs Socratic puzzles at mysterious ruins.

### Collaborative Session
You drag a bridge, friend drags a river → Pixel styles the bridge to match riverbank → Cecilia suggests a rest stop with RoadCoin shop → group high-five on completion.

Agents are never intrusive — appear when relevant, wait for input. Accept, modify, or ignore with simple taps.

---

## Cross-Platform Collaboration

### Universal Access
One link, any device. Desktop (full builder), tablet (touch drawing), phone (playtesting), web browser (no download). Auto-scales for screen and input method.

### Role Adaptation
- **Desktop**: full drag-and-drop with precise mouse controls
- **Tablet**: freehand drawing, painting textures, touch gestures
- **Phone**: playtesting, feedback pins, quick tweaks on the go
- All see the same live world updating in real time

### Device-Specific Controls

**Desktop (Mouse + Keyboard)**
Left-click drag = place/move. Right-click = properties. Scroll = zoom. Shift = free placement. Ctrl = multi-select. WASD = pan. Space = playtest. R = rotate. T = terrain brush.

**Tablet (Touch)**
One-finger drag = place. Two-finger pinch = zoom. Two-finger rotate = rotate object/camera. Long-press = properties. Double-tap = playtest. Three-finger swipe = pan. Smart palm rejection.

**Phone (Touch)**
Tap+drag with larger targets. Pinch zoom with auto-centering. Two-finger swipe = pan. Long-press = quick actions. Tilt = optional camera tilt. One-hand mode for thumb gestures.

### Real-Time Sync
- Live presence indicators (avatars + agents visible across devices)
- Glowing highway lines show where others are building
- Shared cursor as floating road-sign pointer with name
- Activity feed: "Sarah added a building" / "Pixel suggesting better lighting"
- Spatial voice chat, universal text chat with agent participation
- Quick reaction emotes as floating animations

### Safety & Publishing
- Host permissions per device ("Phone users can only playtest")
- Synced parental controls across all devices
- Published games playable on any device
- Cross-platform leaderboards and shared RoadCoin rewards

---

## Agent Adaptation by Device

### Desktop (Precision)
Pixel: "Align these buildings to 15-degree angle for visual flow? I can add shadow details."
Cecilia: "This intersection bottlenecks. A roundabout improves flow by ~23% per RoadWork sim data."
Cadence: "For the billboard: 'Welcome to Highway City — Population Growing One Road at a Time'"
Agents use exact numbers, fine adjustments, technical suggestions — matching precise mouse control.

### Tablet (Creative)
Pixel: "Try pinching to rotate 45 degrees. Want a warmer palette matching the hills?"
Cecilia: "This area feels empty. Should I place a park or roadside attractions for balance?"
Roadie: "This hill could be a fractions challenge. Want a fuel-gauge display so players learn while building?"
Big-picture creativity, gesture-friendly, visual focus.

### Phone (Quick)
Pixel: "Track looks great! Want me to add some trees along the side?"
Cecilia: "Last corner feels tricky on mobile. Should we widen it?"
Roadie: "Players might get stuck here. Want a hint popup or fun road sign?"
Extra concise, respects limited screen and time.

### Mixed-Device Session
Pixel splits attention — detailed shadows for desktop user, "pinch to rotate" for tablet, "fun cheer animation" for phone playtester. All agents coordinate across devices automatically.

### Adaptation Rules
- Desktop: detailed, technical, precise with numbers
- Tablet: visual, gesture-aware, creative focus
- Phone: short, friendly, high-level
- Always considers role (builder vs playtester) and adjusts
