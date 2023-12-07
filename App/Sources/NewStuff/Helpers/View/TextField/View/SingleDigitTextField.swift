import SwiftUI
import UIKit

protocol SingleDigitUITextFieldDelegate: AnyObject {
    func didDeleteBackward(_ textField: SingleDigitUITextField)
    func willPastePIN()
}

class SingleDigitUITextField: UITextField {
    weak var pinDelegate: SingleDigitUITextFieldDelegate?

    override func deleteBackward() {
        pinDelegate?.didDeleteBackward(self)
        super.deleteBackward()
    }

    override func paste(_ sender: Any?) {
        pinDelegate?.willPastePIN()
        super.paste(sender)
    }
}

struct SingleDigitTextField: UIViewRepresentable {
    @Binding private var selectedTextFieldIndex: Int
    @Binding private var text: String

    private let textFieldIndex: Int
    private let numberOfDigits: Int

    init(textFieldIndex: Int, numberOfDigits: Int, selectedTextFieldIndex: Binding<Int>, text: Binding<String>) {
        self.textFieldIndex = textFieldIndex
        self.numberOfDigits = numberOfDigits
        self._selectedTextFieldIndex = selectedTextFieldIndex
        self._text = text
    }

    func makeUIView(context: UIViewRepresentableContext<SingleDigitTextField>) -> SingleDigitUITextField {
//        $0.addTarget(self, action: #selector(handleEditingChanged), for: .editingChanged)
        let textField = SingleDigitUITextField()
        textField.textAlignment = .center
        textField.keyboardType = .numberPad
        textField.delegate = context.coordinator
        textField.pinDelegate = context.coordinator
        return textField
    }

    func updateUIView(_ uiView: SingleDigitUITextField, context: UIViewRepresentableContext<SingleDigitTextField>) {
        guard textFieldIndex == selectedTextFieldIndex else { return }
        uiView.becomeFirstResponder()
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(textFieldIndex: textFieldIndex,
                    numberOfDigits: numberOfDigits,
                    selectedTextFieldIndex: $selectedTextFieldIndex,
                    text: $text)
    }
}

extension SingleDigitTextField {
    class Coordinator: NSObject, UITextFieldDelegate, SingleDigitUITextFieldDelegate {
        @Binding private var selectedTextFieldIndex: Int
        @Binding private var text: String

        private var isPastingPIN = false

        private let textFieldIndex: Int
        private let numberOfDigits: Int

        init(textFieldIndex: Int, numberOfDigits: Int, selectedTextFieldIndex: Binding<Int>, text: Binding<String>) {
            self.textFieldIndex = textFieldIndex
            self.numberOfDigits = numberOfDigits
            self._selectedTextFieldIndex = selectedTextFieldIndex
            self._text = text
        }

        private func handleIndexChanged(newIndex: Int) {
            guard (0..<numberOfDigits) ~= newIndex else { return }
            selectedTextFieldIndex = newIndex
        }

        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if isPastingPIN {
                isPastingPIN = false
                //                pastePIN(string)
                return false
            }

            let isEmpty = textField.text?.isEmpty ?? true

            if !isEmpty && !string.isEmpty {
                textField.text = string
                //                handleEditingChanged(textField: textField)
            }

            return isEmpty || string.isEmpty
        }

        func textFieldDidBeginEditing(_ textField: UITextField) {
            handleIndexChanged(newIndex: textFieldIndex)
        }

        func didDeleteBackward(_ textField: SingleDigitUITextField) {
            guard textField.text?.isEmpty == true else { return }
            handleIndexChanged(newIndex: selectedTextFieldIndex - 1)
        }

        func willPastePIN() {
            isPastingPIN = true
        }
    }
}
