import SwiftUI

struct ActionButton: View {
    enum Style {
        case primary
        case secondary
        case ternary
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
                .font(font)
        }
        .disabled(isDisabled)
        .cornerRadius(8)
        .overlay(
            style == .ternary ? border : nil
        )
    }

    private var foregroundColor: Color {
        switch style {
        case .primary:
            return .primaryText

        case .secondary:
            return isDisabled ? .primaryTint.opacity(0.6) : .primaryTint

        case .ternary:
            return .primaryTint
        }
    }

    private var backgroundColor: Color {
        switch style {
        case .primary:
            return isDisabled ? .gray : .primaryTint

        case .secondary, .ternary:
            return .complementary
        }
    }

    private var font: Font {
        switch style {
        case .primary, .ternary:
            return .system(size: 16, weight: .semibold)

        case .secondary:
            return .system(size: 16, weight: .medium)
        }
    }

    @ViewBuilder
    private var border: some View {
        RoundedRectangle(cornerRadius: 8)
            .stroke(Color.primaryTint, lineWidth: 1)
    }
}

#Preview {
    VStack {
        ActionButton(title: "Primary Button", action: {})
        ActionButton(title: "Secondary Button", style: .secondary, action: {})
        ActionButton(title: "Primary Disabled", isDisabled: .constant(true), action: {})
        ActionButton(title: "Secondary Disabled", style: .secondary, isDisabled: .constant(true), action: {})
        ActionButton(title: "Ternary", style: .ternary, action: {})
    }
}
