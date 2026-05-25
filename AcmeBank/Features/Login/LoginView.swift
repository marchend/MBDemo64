import SwiftUI

/// The login screen presented to unauthenticated users.
///
/// Layout: logo → email field → password field → Sign-in button.
/// The view scrolls to avoid the software keyboard on small screens
/// (SE / 4.7-inch form factor) and advances focus email → password → dismiss.
///
/// Accessibility: every interactive element carries an `accessibilityIdentifier`
/// so XCUITest can locate elements without depending on display strings.
struct LoginView: View {

    // MARK: - Dependencies

    @ObservedObject var viewModel: LoginViewModel

    // MARK: - Focus state

    private enum Field: Hashable {
        case email
        case password
    }

    @FocusState private var focusedField: Field?

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(spacing: LoginView.elementSpacing) {
                Spacer(minLength: 40)

                logoSection

                Spacer(minLength: 24)

                Text("Sign in to AcmeBank")
                    .font(LoginView.titleFont)
                    .foregroundStyle(Color.primary)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 8)

                emailField
                passwordField
                signInButton

                Spacer(minLength: 40)
            }
            .padding(.horizontal, LoginView.horizontalPadding)
        }
        .scrollBounceBehavior(.basedOnSize)
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .background(LoginView.backgroundColor.ignoresSafeArea())
    }

    // MARK: - Sub-views

    private var logoSection: some View {
        Group {
            if UIImage(named: "AcmeBankLogo") != nil {
                Image("AcmeBankLogo")
                    .resizable()
                    .scaledToFit()
            } else {
                // Fallback: text-based logo used until the real asset ships.
                Text("🏦 AcmeBank")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundStyle(LoginView.primaryColor)
            }
        }
        .frame(height: LoginView.logoHeight)
        .accessibilityLabel("AcmeBank logo")
        .accessibilityIdentifier("login_logo")
    }

    private var emailField: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Email")
                .font(LoginView.bodyFont)
                .foregroundStyle(Color.secondary)

            TextField("you@example.com", text: $viewModel.email)
                .keyboardType(.emailAddress)
                .textContentType(.username)
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
                .focused($focusedField, equals: .email)
                .submitLabel(.next)
                .onSubmit { focusedField = .password }
                .padding(12)
                .background(Color(UIColor.secondarySystemGroupedBackground))
                .cornerRadius(LoginView.fieldCornerRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: LoginView.fieldCornerRadius)
                        .stroke(LoginView.fieldBorderColor, lineWidth: 1)
                )
                .accessibilityIdentifier("login_email_field")
        }
    }

    private var passwordField: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Password")
                .font(LoginView.bodyFont)
                .foregroundStyle(Color.secondary)

            SecureField("••••••••", text: $viewModel.password)
                .textContentType(.password)
                .focused($focusedField, equals: .password)
                .submitLabel(.go)
                .onSubmit { handleSignIn() }
                .padding(12)
                .background(Color(UIColor.secondarySystemGroupedBackground))
                .cornerRadius(LoginView.fieldCornerRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: LoginView.fieldCornerRadius)
                        .stroke(LoginView.fieldBorderColor, lineWidth: 1)
                )
                .accessibilityIdentifier("login_password_field")
        }
    }

    private var signInButton: some View {
        Button {
            focusedField = nil
            handleSignIn()
        } label: {
            ZStack {
                Text("Sign in")
                    .font(LoginView.buttonFont)
                    .foregroundStyle(Color.white)
                    .opacity(viewModel.isLoading ? 0 : 1)

                if viewModel.isLoading {
                    ProgressView()
                        .tint(Color.white)
                        .accessibilityIdentifier("login_loading_indicator")
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: LoginView.buttonHeight)
            .background(
                viewModel.isLoading
                    ? LoginView.primaryColor.opacity(0.6)
                    : LoginView.primaryColor
            )
            .cornerRadius(LoginView.fieldCornerRadius)
        }
        .disabled(viewModel.isLoading)
        .padding(.top, 8)
        .accessibilityIdentifier("login_sign_in_button")
    }

    // MARK: - Helpers

    private func handleSignIn() {
        viewModel.signInTapped()
    }
}

// MARK: - Preview

#Preview {
    LoginView(viewModel: LoginViewModel(onSignIn: {}))
}
