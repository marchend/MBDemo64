import XCTest
@testable import AcmeBank

/// Unit tests for `LoginViewModel`.
///
/// Validates default state, the `onSignIn` callback, and the `isLoading` toggle.
/// All assertions run on `MainActor` because the ViewModel is decorated `@MainActor`.
@MainActor
final class LoginViewModelTests: XCTestCase {

    // MARK: - Default state

    func test_defaultState_emailIsEmpty() {
        let sut = LoginViewModel()
        XCTAssertEqual(sut.email, "")
    }

    func test_defaultState_passwordIsEmpty() {
        let sut = LoginViewModel()
        XCTAssertEqual(sut.password, "")
    }

    func test_defaultState_isLoadingFalse() {
        let sut = LoginViewModel()
        XCTAssertFalse(sut.isLoading)
    }

    // MARK: - signInTapped

    func test_signInTapped_setsIsLoadingTrue() {
        let sut = LoginViewModel(onSignIn: {})
        XCTAssertFalse(sut.isLoading, "precondition: isLoading must start false")

        sut.signInTapped()

        XCTAssertTrue(sut.isLoading, "signInTapped should set isLoading to true")
    }

    func test_signInTapped_callsOnSignIn() {
        var didCall = false
        let sut = LoginViewModel(onSignIn: { didCall = true })

        sut.signInTapped()

        XCTAssertTrue(didCall, "signInTapped should invoke the onSignIn closure")
    }

    func test_signInTapped_callsOnSignInExactlyOnce() {
        var callCount = 0
        let sut = LoginViewModel(onSignIn: { callCount += 1 })

        sut.signInTapped()

        XCTAssertEqual(callCount, 1, "onSignIn should be called exactly once per tap")
    }

    func test_signInTapped_setsIsLoadingBeforeCallingOnSignIn() {
        // Verify that isLoading is already true by the time onSignIn runs.
        var isLoadingDuringCallback = false
        var sut: LoginViewModel!
        sut = LoginViewModel(onSignIn: {
            isLoadingDuringCallback = sut.isLoading
        })

        sut.signInTapped()

        XCTAssertTrue(isLoadingDuringCallback,
                      "isLoading must be set to true before invoking onSignIn")
    }

    // MARK: - Published property mutations

    func test_emailAssignment_updatesPublishedProperty() {
        let sut = LoginViewModel()
        sut.email = "test@acmebank.com"
        XCTAssertEqual(sut.email, "test@acmebank.com")
    }

    func test_passwordAssignment_updatesPublishedProperty() {
        let sut = LoginViewModel()
        sut.password = "secret123"
        XCTAssertEqual(sut.password, "secret123")
    }
}
