# Cultivation — Agent Guide

iOS plant care and garden management app built with SwiftUI + Swift 6.

## Prerequisites

| Tool | Install |
|------|---------|
| Xcode 17+ | App Store or `xcode-select --install` |
| XcodeGen | `brew install xcodegen` |
| SwiftLint | `brew install swiftlint` |
| pre-commit | `brew install pre-commit` |

## Setup

```bash
git clone https://github.com/jbcrane13/Cultivation-2.git
cd Cultivation-2
pre-commit install
xcodegen generate
open Cultivation.xcodeproj
```

## Commands

| Task | Command |
|------|---------|
| Regenerate project | `xcodegen generate` |
| Build | `xcodebuild -scheme Cultivation -configuration Debug build` |
| Test | `xcodebuild test -scheme Cultivation -destination 'platform=iOS Simulator,name=iPhone 16'` |
| Lint | `swiftlint` |
| Lint (strict) | `swiftlint --strict` |
| Lint (autocorrect) | `swiftlint --fix` |

## Architecture

```
Cultivation/
├── App/          # @main entry point, ContentView (onboarding gate)
├── Models/       # Pure Swift value types — Plant, UserPreferences enums
├── Services/     # Business logic, networking (currently empty stubs)
└── Views/
    ├── Components/   # Reusable views: PlantCard, SelectionCard
    ├── Dashboard/    # Main tab — weather card + plant list
    ├── Layout/       # Visual garden grid (LazyVGrid)
    ├── Onboarding/   # 3-step first-run flow (step-based state machine)
    ├── Scanner/      # Camera plant ID (mock UI only, no live capture yet)
    └── Settings/     # Pet-safe toggle, debug reset, location
```

### State management
- `@AppStorage("hasCompletedOnboarding")` — persists onboarding gate
- `@State` — all local view state
- No global state manager (no ViewModel layer yet — add if views grow complex)

### Current mock / stub status
- Weather card: hardcoded to Daphne AL / Zone 8b
- Plant data: hardcoded array in `DashboardView`
- Scanner: UI mock only, no `AVFoundation` or plant ID API
- Services/: empty directory, reserved for future networking/persistence

## Coding Conventions

### SwiftUI patterns
- Use `Button { action } label: { view }` — never `Button(action: { }) { view }`
- Keep `body` under 60 lines; extract subviews as `private var` computed properties
- Name extracted sub-views with the suffix `Step`, `Card`, `Row`, or `Section` as appropriate
- Prefer `.ultraThinMaterial` for overlay backgrounds

### Naming
- Types: `UpperCamelCase`
- Properties/functions: `lowerCamelCase`
- SwiftLint enforces `identifier_name` min 2 / max 50 chars

### Files
- One type per file; filename matches type name
- Max 400 lines per file (SwiftLint warning at 400, error at 600)

### Optionals
- Never `= nil` to initialise optional `@State` — use bare `Type?`
- Prefer `guard let` over force-unwrap; force-unwrap is a SwiftLint error

### Logging
- Use the shared `Logger` from `Services/Logger.swift`
- Never log PII (names, locations, device IDs) without `%{private}` formatter
- Format: `logger.info("action: \(value, privacy: .public)")`

## PR Workflow

1. Branch from `main` — `git checkout -b feat/short-description`
2. Run `swiftlint` before pushing (pre-commit hook enforces this)
3. Regenerate the Xcode project if `project.yml` changed: `xcodegen generate`
4. Open a PR — CI runs lint and tests automatically
5. Squash-merge after CI passes

## Security / Secrets

- Never hardcode API keys — use `.env` (gitignored) or Xcode build settings
- See `.env.example` for the list of required variables
- When adding a new secret: add to `.env.example` with a comment, document in this file

## Adding a New Screen

1. Create `Cultivation/Views/<Area>/<Name>View.swift`
2. Register it in `MainTabView.swift` or as a `NavigationLink` destination
3. Add unit tests in `CultivationTests/` if the view has non-trivial logic
4. Run `swiftlint` — fix all violations before committing
