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
