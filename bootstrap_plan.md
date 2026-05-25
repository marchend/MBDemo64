# Bootstrap Plan — AcmeBank iOS App

## In scope (this PR)

### Project name + tech stack decisions
- **App name:** AcmeBank
- **Platform:** iOS 17+, Swift 5.10
- **UI Framework:** SwiftUI (`@main` App entry, `WindowGroup { ContentView() }`)
- **Architecture:** MVVM + Coordinator (deferred); bootstrap uses a single `ContentView`
- **Project mechanism:** XcodeGen (`project.yml`) — never hand-crafted pbxproj
- **Test runner:** XCTest (unit tests in `AcmeBankTests` target)
- **Bundle ID:** `com.acmebank.mobile`
- **Minimum Xcode:** 16.0

### Directory structure (bootstrap only)
```
.
├── project.yml                   # XcodeGen spec — source of truth
├── setup.sh                      # one-shot: installs xcodegen, generates, opens Xcode
├── .gitignore                    # iOS / XcodeGen standard ignores
├── bootstrap_plan.md
├── CLAUDE.md
├── AGENT.md
├── README.md
├── AcmeBank/
│   ├── App/
│   │   ├── AcmeBankApp.swift     # @main SwiftUI entry
│   │   └── ContentView.swift     # Hello World placeholder ("AcmeBank")
│   ├── Resources/
│   │   └── Assets.xcassets/
│   │       ├── Contents.json
│   │       └── AppIcon.appiconset/
│   │           └── Contents.json
│   ├── AcmeBank.entitlements     # stub keychain-access-groups
│   └── PrivacyInfo.xcprivacy     # UserDefaults privacy manifest
└── AcmeBankTests/
    └── AcmeBankTests.swift       # single smoke test: ContentView initialises
```

### Files created in this PR
| File | Purpose |
|---|---|
| `project.yml` | XcodeGen declarative project spec |
| `setup.sh` | One-shot project materialisation script |
| `.gitignore` | Standard iOS / XcodeGen ignores |
| `AcmeBank/App/AcmeBankApp.swift` | `@main` SwiftUI entry point |
| `AcmeBank/App/ContentView.swift` | Hello World view (`Text("AcmeBank")`) |
| `AcmeBank/Resources/Assets.xcassets/Contents.json` | Asset catalog root metadata |
| `AcmeBank/Resources/Assets.xcassets/AppIcon.appiconset/Contents.json` | AppIcon stub (required by actool) |
| `AcmeBank/AcmeBank.entitlements` | Keychain access groups stub |
| `AcmeBank/PrivacyInfo.xcprivacy` | Apple privacy manifest (UserDefaults) |
| `AcmeBankTests/AcmeBankTests.swift` | Bootstrap smoke test |
| `CLAUDE.md` | Project docs for Anthropic agents |
| `AGENT.md` | Project docs for other model families |
| `README.md` | Human-readable quick-start |

### How to run the project locally
```
# After cloning:
./setup.sh
# Opens AcmeBank.xcodeproj in Xcode — press ▶ to build and run
```

Manual fallback:
```
brew install xcodegen
xcodegen generate
open AcmeBank.xcodeproj
```

### How to run tests
In Xcode: `Cmd+U`  
Via CLI: `xcodebuild test -scheme AcmeBank -destination 'platform=iOS Simulator,name=iPhone 16'`

### Definition of Hello World
- The app launches in the iOS Simulator and shows a centered `Text("AcmeBank")` label on a white background.
- One unit test (`test_contentView_initializes`) instantiates `ContentView()` proving the test target compiles and links against the app module.

---

## Out of scope — deferred to future work

- **MVVM + Coordinator pattern** (AppCoordinator, LoginCoordinator, TabBarCoordinator, HomeCoordinator, etc.) — future PR
- **Okta OIDC authentication** (`AuthService`, `KeychainStore`, `UserSession`, `okta-mobile-swift` SPM package) — future PR
- **Networking layer** (`APIClient`, `APIRouter`, `APIError`, `RequestInterceptor`) — future PR
- **Domain models** (`Account`, `Transaction`, `Customer`, `TransferRequest`) — future PR
- **Repository protocols** (`AccountRepositoryProtocol`, `TransactionRepositoryProtocol`, `CustomerRepositoryProtocol`) — future PR
- **Mock data layer** (`MockAccountRepository`, `MockTransactionRepository`, `MockCustomerRepository`) — future PR
- **Remote data layer** (`AccountAPIRepository`, `TransactionAPIRepository`, `CustomerAPIRepository`) — future PR
- **Feature screens** (Login, Home, Accounts, Transfer, Cards, More) — future PRs
- **Design system** (`Colors.swift`, `Typography.swift`, `Assets.xcassets` colour tokens) — future PR
- **Internal notifications** (`AppNotification`, `NotificationPublisher`, `NotificationKey`) — future PR
- **Core extensions** (`Decimal+Currency`, `Date+Greeting`, `String+Initials`) — future PR
- **XCUITest target** (`AcmeBankUITests`) with critical-flow UI tests (Login, Transfer, Sign-out) — future PR
- **SwiftLint** config (`.swiftlint.yml`) and `-warnings-as-errors` xcconfig — future PR
- **CI workflow** (GitHub Actions `ios-build.yml` with `xcodebuild test`) — future PR
- **Localisation** (`Localizable.strings`) — future PR
- **Okta.plist** + `.plist.example` tenant config — future PR (with AuthService story)
- **API_BASE_URL** xcconfig injection — future PR (with networking story)
