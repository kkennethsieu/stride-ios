# NRC Clone — iOS (STRIDE)

A Nike Run Club clone for iOS built with SwiftUI. Features live GPS run tracking, run history with route previews, Firebase authentication, and full backend sync.

> **Backend repo**: [nrc-clone-backend](https://github.com/kkennethsieu/stride-backend)

---

## Demo

> _(Add a GIF or screenshot here)_

---

## Features

- **Live run tracking** — real-time GPS, pace, distance, elevation, and per-mile splits
- **Run history** — activity feed with static route map previews and Swift Charts
- **Authentication** — Sign in with Apple and Google via Firebase Auth
- **Backend sync** — runs synced to a Node.js/Express + Firestore backend
- **SwiftData persistence** — offline-first, runs stored locally and synced on demand
- **Photo capture** — attach a photo to any completed run
- **Local notifications** — post-run summaries and reminders
- **Lottie splash screen**

---

## Tech Stack

|                  |                                                |
| ---------------- | ---------------------------------------------- |
| Language         | Swift                                          |
| UI               | SwiftUI                                        |
| State management | `@Observable`, `@State`, `@Bindable`           |
| Persistence      | SwiftData                                      |
| Networking       | URLSession                                     |
| Location         | CoreLocation                                   |
| Maps             | MapKit (`MKMapSnapshotter`)                    |
| Charts           | Swift Charts                                   |
| Auth             | Firebase Auth iOS SDK (Apple + Google Sign-In) |
| Health           | HealthKit                                      |
| Animation        | Lottie                                         |

---

## Architecture

```
nrc_clone/
├── App/
│   └── nrc_cloneApp.swift         # Entry point, deferred AuthManager init
├── Auth/
│   └── AuthManager.swift          # @Observable Firebase auth + login state
├── Models/
│   ├── RunDetails.swift            # @Model (SwiftData)
│   ├── RunCoordinate.swift         # CLLocationCoordinate2D wrapper (encoded as Data)
│   └── Split.swift
├── ViewModels/
│   ├── RunViewModel.swift          # Live tracking state, split logic, RunState enum
│   └── ActivityViewModel.swift    # Run history, CacheKey-based snapshot caching
├── Views/
│   ├── ContentView.swift           # Root ZStack (tab bar + CountdownOverlay)
│   ├── Auth/                       # Login, onboarding video
│   ├── Activity/                   # Run history feed, RunDetailsView
│   └── Tracking/                  # Live run screen, FinishedRunView
├── Services/
│   └── RunService.swift            # All backend API calls (URLSession)
└── Utilities/
    ├── LocationManager.swift       # @Observable CLLocationManager wrapper
    └── RunFormatter.swift          # SI base units → display strings
```

**Key decisions:**

- `RunState` enum drives all navigation — single source of truth for the full tracking lifecycle (idle → running → paused → finished)
- All values stored in SI base units (meters, seconds); formatted only at display boundaries via `RunFormatter`
- View owns `modelContext` operations; ViewModels have no SwiftUI imports
- `CountdownOverlay` lifted to root `ZStack` to survive tab bar transitions
- `AuthManager` initialization deferred to `init()` to avoid a pre-`FirebaseApp.configure()` crash
- `MapSnapshotView` uses `MKMapSnapshotter` to generate static route images for run cards — avoids live map instances in a scrolling list
- `matchedGeometryEffect` for filter pill animation in the activity feed

---

## Setup

1. **Clone the repo**

   ```bash
   git clone https://github.com/kkennethsieu/stride_ios
   ```

2. **Add `GoogleService-Info.plist`**

   This file is not committed to git. Get it from:

   > Firebase Console → your project → iOS app → Download `GoogleService-Info.plist`

   Drag it into the Xcode project root (make sure "Copy items if needed" is checked).

3. **Install dependencies**

   Firebase iOS SDK is added via Swift Package Manager — Xcode will resolve it automatically on first build.

4. **Configure backend URL**

   In `RunServiceAPI.swift`, set your backend base URL:

   ```swift
   let baseURL = "https://your-backend-url.com"
   ```

5. **Run on a physical device**

   GPS tracking requires real hardware — the simulator does not provide location updates for live runs.

---

## Permissions

The app requests the following permissions at runtime:

| Permission        | Usage                             |
| ----------------- | --------------------------------- |
| Location (Always) | GPS tracking during runs          |
| Camera            | Attach a photo to a completed run |
| Health            | Sync run data to Apple Health     |
| Notifications     | Post-run summaries and reminders  |
