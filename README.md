# Cultivation

A SwiftUI iOS app for plant care and garden management. Features include an onboarding flow, a dashboard with weather context, a visual garden layout, camera-based plant scanning, and pet-safe mode.

## Requirements

- Xcode 17.0+
- iOS 17.0+ deployment target
- [XcodeGen](https://github.com/yonaskolb/XcodeGen) (`brew install xcodegen`)
- [SwiftLint](https://github.com/realm/SwiftLint) (`brew install swiftlint`)

## Setup

```bash
git clone https://github.com/jbcrane13/Cultivation-2.git
cd Cultivation-2
xcodegen generate
open Cultivation.xcodeproj
```

## Build

From the command line:

```bash
xcodebuild -scheme Cultivation -configuration Debug build
```

Or open `Cultivation.xcodeproj` in Xcode and press `Cmd+B`.

## Run Tests

```bash
xcodebuild test -scheme Cultivation -destination 'platform=iOS Simulator,name=iPhone 16'
```

Or press `Cmd+U` in Xcode.

## Lint

```bash
swiftlint
```

SwiftLint runs automatically as an Xcode build phase when the tool is installed.

## Project Structure

```
Cultivation/
├── App/          # App entry point and root ContentView
├── Models/       # Data models (Plant, UserPreferences)
├── Services/     # Business logic and service layer
└── Views/
    ├── Components/   # Reusable UI components
    ├── Dashboard/    # Main garden dashboard
    ├── Layout/       # Visual garden layout grid
    ├── Onboarding/   # First-run experience
    ├── Scanner/      # Camera plant scanner
    └── Settings/     # App settings
```
