import SwiftUI

struct TextInputField: View {
    @Binding private var text: String

    private let placeholder: String
    private let isSecure: Bool

    init(placeholder: String = "", isSecure: Bool, text: Binding<String>) {
        self.placeholder = placeholder
        self.isSecure = isSecure
        self._text = text
    }

    var body: some View {
        VStack {
            textField
                .font(.system(size: 14, weight: .regular))
                .foregroundStyle(Color.textDark)
                .tint(Color.textDark)
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Constants.View.defaultDescriptionLabelPadding)
            Rectangle()
                .fill(Color.textDark)
                .padding(.horizontal, Constants.View.defaultDescriptionLabelPadding)
                .frame(height: 1)
        }
    }

    @ViewBuilder
    private var textField: some View {
        if isSecure {
            SecureField(placeholder, text: $text)
        } else {
            TextField(placeholder, text: $text)
        }
    }
}

#Preview {
    VStack {
        TextInputField(placeholder: "", isSecure: false, text: .constant("Text"))
        TextInputField(placeholder: "", isSecure: true, text: .constant("Text"))
    }
}
