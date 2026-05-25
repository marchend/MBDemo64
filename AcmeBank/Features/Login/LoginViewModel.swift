import Foundation

/// ViewModel for the Login screen.
///
/// Exposes published state for the email field, password field, and loading
/// indicator. The `onSignIn` closure is injected by the caller (coordinator
/// or, in this PR, the app entry point) so the ViewModel remains independent
/// of navigation.
///
/// Note: Real Okta authentication is wired in a companion story. This PR
/// ships the stubbed closure so the UI can be built, tested, and presented
/// end-to-end without a live Okta tenant.
@MainActor
final class LoginViewModel: ObservableObject {
    // MARK: - Published state

    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false

    // MARK: - Injected behaviour

    /// Called when the user taps "Sign in" and all validation passes.
    /// Defaults to a no-op so previews and unit tests that don't need to
    /// observe the callback compile without extra boilerplate.
    var onSignIn: () -> Void

    // MARK: - Init

    init(onSignIn: @escaping () -> Void = {}) {
        self.onSignIn = onSignIn
    }

    // MARK: - Actions

    /// Called by the view when the user taps the "Sign in" button.
    /// Sets `isLoading = true` then invokes the injected closure.
    /// Real Okta authentication replaces this stub in a future story.
    func signInTapped() {
        isLoading = true
        onSignIn()
    }
}
