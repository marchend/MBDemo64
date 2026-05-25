# AcmeBank iOS

An iOS 17+ banking app built with SwiftUI, MVVM + Coordinator, and Okta OIDC authentication.

> **Bootstrap state:** this repo currently contains the Hello-World scaffold.
> Feature work (auth, networking, screens) lands in follow-up PRs.

## Quick Start

```bash
# Clone, then:
./setup.sh
```

The script installs [XcodeGen](https://github.com/yonaskolb/XcodeGen) if missing,
generates `AcmeBank.xcodeproj` from `project.yml`, and opens it in Xcode.

**Manual fallback** (for environments that block shell scripts):
```bash
brew install xcodegen
xcodegen generate
open AcmeBank.xcodeproj
```

Then press **⌘R** to run on the iOS Simulator.

## Running Tests

```bash
# Xcode shortcut: Cmd+U

# CLI:
xcodebuild test \
  -scheme AcmeBank \
  -destination 'platform=iOS Simulator,name=iPhone 16' \
  CODE_SIGNING_ALLOWED=NO
```

## Tech Stack

| Item | Value |
|---|---|
| Platform | iOS 17+, Swift 5.10, Xcode 16+ |
| UI | SwiftUI |
| Architecture | MVVM + Coordinator |
| Auth | Okta OIDC (`okta-mobile-swift`) |
| Networking | URLSession + async/await |
| Project file | XcodeGen (`project.yml`) |

## Project Layout

```
AcmeBank/          # App source (App/, Core/, Domain/, Data/, Features/, DesignSystem/)
AcmeBankTests/     # XCTest unit tests
project.yml        # XcodeGen spec — source of truth (never edit .xcodeproj directly)
setup.sh           # One-shot project setup
```

## Branch Model

| Branch  | Role                       |
|---------|----------------------------|
| develop | Default integration branch |
| qa      | First quality gate         |
| uat     | Pre-prod acceptance        |
| main    | Production                 |

All feature PRs target **`develop`**.
