import SwiftUI

struct ActionButton: View {
    enum Style {
        case primary
        case secondary
    }

    @Binding private var isDisabled: Bool

    private let title: String
    private let style: Style
    private let action: () -> Void

    init(title: String,
         style: Style = .primary,
         isDisabled: Binding<Bool> = .constant(false),
         action: @escaping () -> Void) {
        self.title = title
        self.style = style
        self._isDisabled = isDisabled
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Text(title)
                .frame(maxWidth: .infinity, minHeight: 50)
                .foregroundStyle(foregroundColor)
                .background(backgroundColor)
                .font(style == .primary ? .system(size: 14, weight: .semibold) : .system(size: 16, weight: .medium))
        }
        .disabled(isDisabled)
        .cornerRadius(8)
        .padding(.horizontal, Constants.View.defaultButtonPadding)
    }

    private var foregroundColor: Color {
        switch style {
        case .primary:
            return .textLight

        case .secondary:
            return isDisabled ? .textDark.opacity(0.6) : .textDark
        }
    }

    private var backgroundColor: Color {
        switch style {
        case .primary:
            return isDisabled ? .disabled : .primaryTint

        case .secondary:
            return .clear
        }
    }
}

#Preview {
    VStack {
        ActionButton(title: "Primary Button", action: {})
        ActionButton(title: "Secondary Button", style: .secondary, action: {})
        ActionButton(title: "Primary Disabled", isDisabled: .constant(true), action: {})
        ActionButton(title: "Secondary Disabled", style: .secondary, isDisabled: .constant(true), action: {})
    }
}
