import SwiftUI

struct SingleDigitTextFieldOld: View {
    enum FocusedField {
        case text
    }

    @FocusState var focusedField: FocusedField?
    @Binding private var text: String

    init(text: Binding<String>) {
        self._text = text
    }

    var body: some View {
        TextField("", text: $text)
            .frame(width: 50, height: 50)
            .font(.system(size: 20))
            .multilineTextAlignment(.center)
            .foregroundStyle(Color.genericBlack)
            .background(Color.genericWhite)
            .tint(.genericBlack)
            .keyboardType(.numberPad)
            .multilineTextAlignment(.center)
            .focused($focusedField, equals: .text)
            .overlay(
                RoundedRectangle(cornerRadius: .cornerRadius)
                    .stroke(Color.genericGrey, lineWidth: 1)
            )
    }
}

#Preview {
    SingleDigitTextFieldOld(text: .constant("1"))
}
