import SwiftUI

@main
struct AcmeBankApp: App {
    var body: some Scene {
        WindowGroup {
            // LoginView is the entry point for unauthenticated users.
            // Real post-login navigation (TabBarCoordinator) is wired
            // in a companion story once Okta auth is integrated.
            LoginView(viewModel: LoginViewModel())
        }
    }
}
