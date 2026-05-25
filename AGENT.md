# AcmeBank — Project Context

## Overview
AcmeBank is an iOS 17+ banking app built in Swift/SwiftUI. It lets customers
view accounts and transactions, initiate transfers, manage cards, and pay bills —
all secured via Okta OIDC authentication. This repo currently contains the
bootstrap Hello-World scaffold; all feature work lands in follow-up PRs.

## Tech Stack
| Item | Value |
|---|---|
| Platform | iOS 17+, Swift 5.10, Xcode 16+ |
| UI Framework | SwiftUI (`@main App` + `WindowGroup`) |
| Architecture | MVVM + Coordinator (`NavigationStack`) |
| Auth | Okta OIDC — `okta-mobile-swift` 2.x |
| Networking | `URLSession` + async/await |
| DI | Constructor injection (no service locator) |
| Notifications | `NotificationCenter` with typed wrappers |
| Project file | XcodeGen (`project.yml`) — never hand-edit pbxproj |
| Test runner | XCTest (unit); XCUITest (critical UI flows) |
| Bundle ID | `com.acmebank.mobile` |

## Running Locally
```bash
# After cloning (one-time):
./setup.sh          # installs xcodegen, generates .xcodeproj, opens Xcode

# Manual fallback:
brew install xcodegen
xcodegen generate
open AcmeBank.xcodeproj
```
Press **⌘R** in Xcode to build and run on the iOS Simulator.

## Running Tests
```bash
# In Xcode: Cmd+U
# Via CLI:
xcodebuild test \
  -scheme AcmeBank \
  -destination 'platform=iOS Simulator,name=iPhone 16' \
  CODE_SIGNING_ALLOWED=NO
```

## Key Directory Structure
```
AcmeBank/
├── App/              # @main entry + root ContentView (implemented)
├── Core/             # Auth, Networking, Notifications, Extensions (deferred)
├── Domain/           # Models + Repository protocols (deferred)
├── Data/             # Remote + Mock repository implementations (deferred)
├── Features/         # Login, Home, Accounts, Transfer, Cards, More (deferred)
├── DesignSystem/     # Colors, Typography, Assets (deferred)
└── Resources/        # Assets.xcassets, PrivacyInfo.xcprivacy
AcmeBankTests/        # XCTest unit tests
AcmeBankUITests/      # XCUITest critical-flow tests (deferred)
project.yml           # XcodeGen spec — source of truth
setup.sh              # one-shot materialisation script
```

## Planned Architecture

### Entry point (implemented in this PR)
- `AcmeBankApp.swift` — `@main` SwiftUI App, `WindowGroup { ContentView() }`
- `ContentView.swift` — Hello World placeholder

### MVVM + Coordinator (deferred — future PR)
- `AppCoordinator` (ObservableObject) observed by `RootView`
- `LoginCoordinator` → full-screen when unauthenticated
- `TabBarCoordinator` → root TabView after login
  - `HomeCoordinator`, `TransferCoordinator`, `CardsCoordinator`, `MoreCoordinator`
- Each coordinator owns a `NavigationStack(path:)`; child screens pushed via typed routes

### Authentication — Okta OIDC (deferred — future PR)
- `AuthService` (`okta-mobile-swift` 2.x) — sign-in / sign-out / token refresh
- `KeychainStore` — secure token persistence (use `kSecUseDataProtectionKeychain: true` in all Keychain queries for CI compatibility)
- `UserSession` — value type passed through coordinators; never stored in UserDefaults

### Networking (deferred — future PR)
- `APIClient` — `URLSession` + async/await; decodes JSON with snake_case + ISO8601
- `APIRouter` — typed endpoint enum
- `RequestInterceptor` — injects Bearer token; posts `sessionExpired` on 401

### Domain Models (deferred — future PR)
- `Account`, `Transaction`, `Customer`, `TransferRequest`

### Repository layer (deferred — future PR)
- Protocols in `Domain/Repositories/`; concrete types in `Data/Remote/` and `Data/Mock/`
- ViewModels depend only on protocols — never on concrete types

### Design System (deferred — future PR)
- `Colors.swift` — `Color.acmeNavy`, `.acmeBackground`, `.acmeGreen`, etc.
- `Typography.swift` — `Font.acmeTitle`, `.acmeHeadline`, `.acmeBody`, etc.

### Internal Notifications (deferred — future PR)
- `AppNotification` — typed `Notification.Name` constants
- `NotificationPublisher` — static `post(_:userInfo:)` helper
- Subscriptions live in coordinators — never in ViewModels

### XCUITest critical flows (deferred — future PR)
- `LoginUITests`, `TransferUITests` — launch with `-UITestMode YES`, inject mocks

## Keychain Notes (for future feature agents)
Every Keychain query MUST include `kSecUseDataProtectionKeychain: true` so
tests pass in CI's `CODE_SIGNING_ALLOWED=NO` simulator environment.

## Deferred Work
- MVVM + Coordinator wiring (AppCoordinator, LoginCoordinator, TabBarCoordinator…)
- Okta OIDC auth (AuthService, KeychainStore, UserSession, okta-mobile-swift SPM)
- Networking layer (APIClient, APIRouter, APIError, RequestInterceptor)
- Domain models (Account, Transaction, Customer, TransferRequest)
- Repository protocols + Remote + Mock implementations
- All feature screens (Login, Home, Accounts, Transfer, Cards, More)
- Design system (Colors, Typography)
- Internal notifications (AppNotification, NotificationPublisher)
- XCUITest target + critical-flow UI tests
- SwiftLint config (`.swiftlint.yml`) + `-warnings-as-errors` xcconfig
- GitHub Actions CI workflow (`ios-build.yml`)
- Localisation (`Localizable.strings`)
- Okta.plist / `.plist.example` + `API_BASE_URL` xcconfig injection

## Git Workflow

> **Default PR target branch: `develop`.** Every feature/refactor/docs PR
> opens against `develop`. PRs are only opened against `qa`, `uat`, or
> `main` for explicit promotion PRs.

**Branch model (`develop` → `qa` → `uat` → `main`):**

| Branch  | Role                                 | Receives PRs from              | Promotes to |
|---------|--------------------------------------|--------------------------------|-------------|
| develop | Default integration branch           | feature branches               | qa          |
| qa      | First quality gate                   | develop (promotion PR)         | uat         |
| uat     | Pre-prod acceptance                  | qa (promotion PR)              | main        |
| main    | Production / release tags            | uat (promotion PR)             | tagged only |

All feature PRs MUST target `develop`. Never open a feature PR against
`qa`, `uat`, or `main`. Promotions happen via dedicated promotion PRs.
