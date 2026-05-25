import SwiftUI

/// Bootstrap placeholder — no longer the app entry point.
/// The app launches into `LoginView` (see `AcmeBankApp.swift`).
/// This file is retained so that legacy references compile cleanly;
/// it will be removed when the Coordinator layer ships.
struct ContentView: View {
    var body: some View {
        LoginView(viewModel: LoginViewModel())
    }
}

#Preview {
    ContentView()
}
