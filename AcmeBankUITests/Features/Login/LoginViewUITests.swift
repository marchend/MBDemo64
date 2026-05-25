import XCTest

/// XCUITest suite for the Login screen.
///
/// Verifies that the interactive elements are present, hittable, and
/// respond correctly to user input.  Tests use accessibility identifiers
/// (not display strings) so they don't break on copy changes.
///
/// The app under test uses a stubbed `onSignIn` closure — no real Okta
/// network traffic occurs during these tests.
final class LoginViewUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
        try super.tearDownWithError()
    }

    // MARK: - Element presence

    func test_loginScreen_emailFieldExists() {
        let emailField = app.textFields["login_email_field"]
        XCTAssertTrue(emailField.waitForExistence(timeout: 5),
                      "Email text field should be present on the login screen")
    }

    func test_loginScreen_passwordFieldExists() {
        let passwordField = app.secureTextFields["login_password_field"]
        XCTAssertTrue(passwordField.waitForExistence(timeout: 5),
                      "Password secure text field should be present on the login screen")
    }

    func test_loginScreen_signInButtonExists() {
        let signInButton = app.buttons["login_sign_in_button"]
        XCTAssertTrue(signInButton.waitForExistence(timeout: 5),
                      "Sign-in button should be present on the login screen")
    }

    // MARK: - Hittability

    func test_loginScreen_emailFieldIsHittable() {
        let emailField = app.textFields["login_email_field"]
        XCTAssertTrue(emailField.waitForExistence(timeout: 5))
        XCTAssertTrue(emailField.isHittable,
                      "Email field should be hittable (not obscured or offscreen)")
    }

    func test_loginScreen_signInButtonIsHittable() {
        let signInButton = app.buttons["login_sign_in_button"]
        XCTAssertTrue(signInButton.waitForExistence(timeout: 5))
        XCTAssertTrue(signInButton.isHittable,
                      "Sign-in button should be hittable")
    }

    // MARK: - Field interaction

    func test_emailField_acceptsTextInput() {
        let emailField = app.textFields["login_email_field"]
        XCTAssertTrue(emailField.waitForExistence(timeout: 5))

        emailField.tap()
        emailField.typeText("user@acmebank.com")

        XCTAssertEqual(emailField.value as? String, "user@acmebank.com",
                       "Email field should display the typed text")
    }

    func test_passwordField_acceptsTextInput() {
        let passwordField = app.secureTextFields["login_password_field"]
        XCTAssertTrue(passwordField.waitForExistence(timeout: 5))

        passwordField.tap()
        passwordField.typeText("secret123")

        // SecureField value is masked; we verify the field was interacted with
        // by confirming it is not empty (value becomes "•••••••••" or similar).
        let value = passwordField.value as? String ?? ""
        XCTAssertFalse(value.isEmpty,
                       "Password field should reflect typed text (masked)")
    }

    // MARK: - Button tap

    func test_signInButton_tapDoesNotCrash() {
        // Fill in fields first so the tap is realistic.
        let emailField = app.textFields["login_email_field"]
        XCTAssertTrue(emailField.waitForExistence(timeout: 5))
        emailField.tap()
        emailField.typeText("user@acmebank.com")

        let passwordField = app.secureTextFields["login_password_field"]
        passwordField.tap()
        passwordField.typeText("secret123")

        let signInButton = app.buttons["login_sign_in_button"]
        XCTAssertTrue(signInButton.waitForExistence(timeout: 5))
        signInButton.tap()

        // The stub onSignIn does nothing; verify the app is still alive.
        XCTAssertTrue(app.state == .runningForeground,
                      "App should remain in the foreground after tapping Sign In")
    }

    // MARK: - Accessibility identifiers

    func test_accessibilityIdentifiers_allInteractiveElementsPresent() {
        XCTAssertTrue(
            app.textFields["login_email_field"].waitForExistence(timeout: 5),
            "login_email_field accessibility identifier must be present"
        )
        XCTAssertTrue(
            app.secureTextFields["login_password_field"].exists,
            "login_password_field accessibility identifier must be present"
        )
        XCTAssertTrue(
            app.buttons["login_sign_in_button"].exists,
            "login_sign_in_button accessibility identifier must be present"
        )
    }
}
