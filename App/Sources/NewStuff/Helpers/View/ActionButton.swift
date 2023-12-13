import SwiftUI

struct ActionButton: View {
    enum Style {
        case primary
        case secondary
    }

    @Binding private var isLoading: Bool
    @Binding private var isDisabled: Bool

    private let title: String
    private let style: Style
    private let action: () -> Void

    private let disabledOpacity: CGFloat = 0.4

    init(title: String,
         style: Style = .primary,
         isLoading: Binding<Bool> = .constant(false),
         isDisabled: Binding<Bool> = .constant(false),
         action: @escaping () -> Void) {
        self.title = title
        self.style = style
        self._isLoading = isLoading
        self._isDisabled = isDisabled
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            if isLoading {
                LoadingSpinner(color: loadingSpinnerColor, size: 30)
            } else {
                Text(title)
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .foregroundStyle(foregroundColor)
                    .font(.system(size: 16, weight: .bold))
            }
        }
        .frame(maxWidth: .infinity, minHeight: 50)
        .background(backgroundColor)
        .disabled(isDisabled)
        .cornerRadius(.cornerRadius)
        .overlay(
            style == .secondary ? border : nil
        )
    }

    private var loadingSpinnerColor: Color {
        switch (style, isDisabled) {
        case (.primary, false):
            return .genericBlack

        default:
            return .primaryTint
        }
    }

    private var foregroundColor: Color {
        let color: Color = style == .primary ? .textButtons : .primaryTint
        return color.opacity(isDisabled ? disabledOpacity : 1)
    }

    private var backgroundColor: Color {
        switch style {
        case .primary:
            return .primaryTint.opacity(isDisabled ? disabledOpacity : 1)

        case .secondary:
            return .genericWhite
        }
    }

    @ViewBuilder
    private var border: some View {
        let strokeColor: Color = .primaryTint.opacity(isDisabled ? disabledOpacity : 1)
        RoundedRectangle(cornerRadius: .cornerRadius)
            .stroke(strokeColor, lineWidth: 1)
    }
}

#Preview {
    VStack {
        ActionButton(title: "Primary Button", action: {})
        ActionButton(title: "Secondary Button", style: .secondary, action: {})
        ActionButton(title: "Primary Disabled", isDisabled: .constant(true), action: {})
        ActionButton(title: "Secondary Disabled", style: .secondary, isDisabled: .constant(true), action: {})
        ActionButton(title: "Loading Primary Button Enabled", isLoading: .constant(true), action: {})
        ActionButton(title: "Loading Primary Button Disabled", isLoading: .constant(true), isDisabled: .constant(true), action: {})
        ActionButton(title: "Loading Secondary Button Enabled", style: .secondary, isLoading: .constant(true), action: {})
        ActionButton(title: "Loading Secondary Button Disabled", style: .secondary, isLoading: .constant(true), isDisabled: .constant(true), action: {})
    }
}
