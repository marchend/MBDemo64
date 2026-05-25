import SwiftUI

// MARK: - Design tokens for LoginView
//
// These constants mirror the planned DesignSystem (deferred to a future PR).
// When Colors.swift / Typography.swift land, replace these literals with the
// shared tokens and delete this extension.
//
// TODO: replace literals with `Color.acmeNavy`, `Font.acmeBody`, etc. once
// the DesignSystem module ships.

extension LoginView {
    // MARK: Colours

    /// Primary brand colour used for the Sign-in button background.
    static let primaryColor = Color(red: 0.09, green: 0.26, blue: 0.54)   // Acme Navy

    /// Subtle background tint for the whole screen.
    static let backgroundColor = Color(UIColor.systemGroupedBackground)

    /// Tint applied to the field borders and focus rings.
    static let fieldBorderColor = Color(UIColor.separator)

    // MARK: Typography

    /// Title font used for the "Sign in" heading below the logo.
    static let titleFont: Font = .system(size: 26, weight: .bold, design: .rounded)

    /// Body font for field labels and helper text.
    static let bodyFont: Font = .system(size: 15, weight: .regular)

    /// Button label font.
    static let buttonFont: Font = .system(size: 17, weight: .semibold)

    // MARK: Layout

    /// Corner radius applied to text fields and the primary button.
    static let fieldCornerRadius: CGFloat = 10

    /// Height of the primary "Sign in" button.
    static let buttonHeight: CGFloat = 50

    /// Vertical spacing between form elements.
    static let elementSpacing: CGFloat = 16

    /// Horizontal padding applied to the content card.
    static let horizontalPadding: CGFloat = 24

    /// Height of the logo image well.
    static let logoHeight: CGFloat = 72
}
