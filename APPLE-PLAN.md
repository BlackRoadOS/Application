# BlackRoad OS — Apple App Store Plan

**Remember the Road. Pave Tomorrow.**

---

## The Strategy: PWA First, Native Wrapper, Then Full Native

### Phase 1: PWA (Already Live — Week 1)

BlackRoad OS already works as a Progressive Web App. app.blackroad.io has:
- `<meta name="apple-mobile-web-app-capable" content="yes">`
- `<link rel="manifest" href="/manifest.json">`
- Full-screen mode, theme color, viewport settings

**Action items:**
- [ ] Verify manifest.json has correct icons (192x192, 512x512 PNG)
- [ ] Add apple-touch-icon (180x180)
- [ ] Test "Add to Home Screen" on iPhone — should launch full-screen
- [ ] Submit to PWA directories (Progressier, PWABuilder)

### Phase 2: WebView Native Wrapper (Week 2-3)

Use Capacitor (Ionic) or Tauri Mobile to wrap the existing web apps in a native iOS shell. This gets us into the App Store fast with minimal code changes.

**Architecture:**
```
iOS App (Swift shell)
├── WKWebView loading app.blackroad.io
├── Native: push notifications (APNs)
├── Native: biometric auth (Face ID / Touch ID → CarKeys)
├── Native: camera access (for BlackBoard scanning)
├── Native: haptic feedback
├── Native: Share extension ("Share to BackRoad")
└── Native: Widget (Roadie daily problem, RoadCoin balance)
```

**Tech stack:**
- Capacitor 6 or Tauri Mobile (Rust + WebView)
- Swift for native bridges (notifications, biometrics, camera)
- Xcode 16+ for build/submit

**Action items:**
- [ ] `npm install @capacitor/core @capacitor/ios`
- [ ] `npx cap init BlackRoadOS io.blackroad.app`
- [ ] Configure WKWebView to load app.blackroad.io
- [ ] Add native push notification bridge (APNs)
- [ ] Add Face ID / Touch ID for CarKeys authentication
- [ ] Add Share extension for BackRoad posting
- [ ] Add iOS widget: Roadie daily challenge + RoadCoin balance
- [ ] App icon (1024x1024) — use brand colors, road mark
- [ ] Screenshots for App Store (6.7", 6.1", 5.5" iPhones + iPad)
- [ ] App Store description, keywords, category

### Phase 3: App Store Submission (Week 3-4)

**App Store Requirements:**
- [ ] Apple Developer Account ($99/year) — enroll at developer.apple.com
- [ ] App Review Guidelines compliance check:
  - No private API usage
  - No external payment links that bypass IAP (for digital goods)
  - Privacy nutrition labels filled out
  - App Tracking Transparency if any tracking
- [ ] Privacy Policy URL (blackroad.io/privacy — already exists)
- [ ] Support URL (blackroad.io — already exists)
- [ ] Age Rating: 4+ (Roadie is kid-safe) or 12+ if social features included
- [ ] TestFlight beta (invite 5-10 testers first)

**App Store Listing:**
```
Name: BlackRoad OS
Subtitle: AI That Remembers You
Category: Productivity (primary), Education (secondary)
Price: Free (IAP for $10/module, $100/everything)

Description:
Your entire digital life in one app. 14 AI-powered products.
One highway. Your Roadies ride with you.

• Roadie — AI homework help that teaches, not tells
• RoadTrip — 18 AI agents that remember every conversation
• BackRoad — Post everywhere on autopilot
• BlackBoard — Create ads, videos, infographics
• RoadWork — Your business runs itself
• RoadCode — Code and deploy from your phone
• RoadView — Search with blockchain-verified answers
• CarKeys — One keychain for your entire digital life
• RoadChain — Every action tamper-proof
• RoadCoin — Earn fuel for everything you do

Free for a month. $10/module or $100/everything after.
Your data is yours. Export anytime. Pave Tomorrow.

Keywords: AI,homework,tutor,agents,social,automation,creator,code,blockchain,productivity
```

### Phase 4: Native Features (Month 2-3)

Once the wrapper is approved, start adding native capabilities:

- [ ] **Siri Shortcuts**: "Hey Siri, ask Roadie about quadratic equations"
- [ ] **Live Activities**: Show RoadCoin balance, agent activity on Lock Screen
- [ ] **Spotlight Search**: Index Roadie topics, RoadTrip conversations
- [ ] **Handoff**: Start on Mac, continue on iPhone
- [ ] **iCloud Keychain**: Bridge with CarKeys
- [ ] **HealthKit**: Roadie can track study time as "mindful minutes"
- [ ] **Notification Groups**: Separate channels for Roadie, RoadTrip, BackRoad, RoadWork
- [ ] **App Clips**: Scan QR → instant Roadie session (no install)

### Phase 5: Full SwiftUI Native (Month 4-6)

If the wrapper gets traction, rebuild key screens in native SwiftUI for:
- Silky 120Hz animations
- Better offline support
- Native navigation (swipe back, pull to refresh)
- CarKeys → Keychain integration
- RoadTrip → native group chat feel
- Roadie → native quiz/flashcard UI

---

## IAP Strategy (In-App Purchase)

Apple takes 30% of digital goods sold through the App Store. We need to handle this carefully.

| Product | IAP Required? | Strategy |
|---------|-------------|----------|
| Roadie ($10/mo) | Yes — digital service | Auto-renewable subscription via StoreKit |
| RoadTrip ($10/mo) | Yes — digital service | Auto-renewable subscription |
| Everything ($100/mo) | Yes — digital service | Auto-renewable subscription |
| RoadCoin purchase | Yes — consumable IAP | Consumable purchase |
| RoadCoin earn | No — user-generated | Free (earned through usage) |
| Physical goods (merch) | No | Can link to web checkout |

**Pricing after Apple's 30% cut:**
- $10/mo → Apple gets $3, BlackRoad gets $7
- $100/mo → Apple gets $30, BlackRoad gets $70
- Small Developer Program (first $1M at 15%) → $10 → $8.50 to BlackRoad

**Action items:**
- [ ] Set up StoreKit 2 in Xcode
- [ ] Create auto-renewable subscription group ("BlackRoad")
- [ ] Products: roadie_monthly ($9.99), everything_monthly ($99.99)
- [ ] Consumable: roadcoin_100 ($0.99), roadcoin_1000 ($7.99)
- [ ] Server-side receipt validation via App Store Server API
- [ ] Apply for Small Business Program (15% commission on first $1M)

---

## Timeline

| Week | Milestone |
|------|-----------|
| 1 | PWA verified, manifest + icons, Add to Home Screen works |
| 2 | Capacitor project init, WKWebView shell, basic native bridges |
| 3 | Push notifications, Face ID, Share extension, widget |
| 4 | TestFlight beta, App Store listing prepared, screenshots |
| 5 | Submit to App Store Review |
| 6 | **App Store launch** |
| 8 | Siri Shortcuts, Live Activities, App Clips |
| 12 | Native SwiftUI screens for Roadie + RoadTrip |

---

## Android (Parallel Track)

Same strategy but easier — Google Play allows PWAs as-is and Capacitor builds Android simultaneously.

- [ ] `npx cap add android`
- [ ] Google Play Developer Account ($25 one-time)
- [ ] Play Store listing (reuse App Store copy)
- [ ] Submit — Google review is faster (hours vs days)

---

*Pave Tomorrow.*
