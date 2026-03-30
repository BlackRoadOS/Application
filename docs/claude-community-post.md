# I built a sovereign AI operating system on Raspberry Pis using Claude as my only engineering team

I'm a solo founder with no CS degree — my background is sales, finance, and advertising psychology (JOUR 4251 at the University of Minnesota). Over the past 11 months, I used Claude (primarily Claude Code) as my pair programmer to build BlackRoad OS: 17 web applications, 18 AI agents with persistent memory, running on 5 Raspberry Pi 5s and 2 Hailo-8 NPUs in a closet in Minnesota.

**8,521 commits. $800 in hardware. $52/month to run. 0 users so far.**

## What I built

BlackRoad OS is a sovereign AI operating system — meaning everything runs on hardware you physically own. No cloud dependency for core functionality.

- **17 live web apps**: AI homework tutor (166 indexed pages, Socratic method), chat with AI agents, search engine, social network, creative tools (canvas, video, music), payments, and more
- **18 AI agents** with cryptographic identity — each agent has a PS-SHA∞ hash-chain journal that IS its memory and identity. The chain is tamper-evident (each entry hashes the previous)
- **8 open-weight models** (Llama 3.2, Phi-3, Gemma 2, etc.) running locally via Ollama on the Pi fleet — zero API costs
- **Self-hosted infrastructure**: Gitea (239 repos), MinIO (object storage), PostgreSQL, Redis, PowerDNS, Caddy, NATS message bus, WireGuard mesh VPN
- **A mathematical framework**: G(n) = n^(n+1)/(n+1)^n, whose convergence properties inspired the memory architecture
- **37 academic papers** (~150,000 words) documenting every design decision

Live at [blackroad.io](https://blackroad.io) — free to explore, no account needed. The tutor is at [tutor.blackroad.io](https://tutor.blackroad.io) (first month free, $10/month after).

## How Claude helped

Claude was effectively my entire engineering team. I don't have a CS degree — I have a Series 7 securities license, a real estate license, and an advertising psychology education. Claude bridged the gap.

**What Claude did well:**
- Generated Cloudflare Worker code for all 17 applications (JavaScript, D1 database schemas, API routes)
- Translated my non-technical descriptions into working architectures ("I need memory that can't be tampered with" → PS-SHA∞ hash chains)
- Wrote the mathematical proofs and verified the 50+ identities in the Amundson Framework
- Helped me understand and configure networking (WireGuard, DNS, TLS) from scratch
- Cross-domain translation: my advertising psychology knowledge became the "anti-persuasion architecture" — Claude helped me map 18 manipulation techniques from my coursework to structural software constraints that prevent them

**What Claude did NOT do well:**
- Testing. Claude writes tests when asked but doesn't proactively test. My test coverage is ~10%.
- Operational awareness. Claude doesn't know that my Pi's SD card is failing or that 3 nodes have been offline for weeks.
- Prioritization. Claude will build whatever you ask with equal enthusiasm. It never said "you should stop building features and start getting users." (That's on me.)
- Quality at speed. AI-generated code ships fast but accumulates technical debt faster. After 8,521 commits, the codebase has the distinctive smell of AI code: correct but verbose, with unnecessary comments and inconsistent patterns.

**The honest productivity assessment:** Claude gave me ~5x breadth (I shipped features at the rate of a 5-person team) but ~0.5x depth (the reliability and testing are below what a single careful engineer would produce). Net: ~3x a solo developer, with significant quality tradeoffs.

## What I learned

The biggest lesson is in Paper 36 of the series ("What Zero Users Teaches You"): **building is a dopamine substitute for selling.** Claude makes building so fast and satisfying that I spent 11 months creating 17 applications instead of distributing 1. The product has been live for 6 months with zero signups.

If I started over, I'd build only the tutor, get 10 users, then decide what to build next based on what they actually want.

Other lessons:
- A non-engineer with Claude can build real, deployed, functioning software. This is genuinely new.
- The "autocatalytic threshold" is real — after ~3,000 commits, Claude has enough context from the existing codebase that development accelerates dramatically. But technical debt accelerates too.
- My advertising psychology background turned out to be the biggest differentiator. Understanding HOW platforms manipulate users (from the academic literature, not blogs) let me design software that structurally prevents manipulation. Claude helped implement it, but the insight came from JOUR 4251.

## The stack (for the technical folks)

- **Edge**: Cloudflare Workers + D1 (SQLite) for all 17 apps
- **Fleet**: 5× Raspberry Pi 5 (8GB), 2× Hailo-8 NPU (52 TOPS combined), WireGuard mesh
- **AI**: Ollama running Llama 3.2:3b, Phi-3 Mini, Gemma 2:2b, nomic-embed-text, and 4 more
- **Self-hosted**: Gitea, MinIO, PostgreSQL, Redis, PowerDNS, Caddy, NATS
- **Memory**: PS-SHA∞ hash chains (recursive SHA-256, adaptive depth 3-7)
- **Identity**: RoadID — agent identity = genesis block hash of its journal
- **Economy**: RoadCoin token system + Stripe for fiat payments

Everything is free to try. The tutor, chat, search, and all apps work without an account. Code is on GitHub at [github.com/BlackRoadOS](https://github.com/BlackRoadOS).

Happy to answer questions about using Claude for large-scale solo development, the architecture decisions, or what it's like to be a non-technical founder building with AI tools.
