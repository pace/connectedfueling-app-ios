// Copyright © 2024 PACE Telematics GmbH. All rights reserved.

import SwiftUI
import UIKit

protocol SingleDigitTextFieldDelegate: AnyObject {
    func didDeleteBackward(_ textField: SingleDigitTextField)
    func willPastePIN()
}

struct SingleDigitsTextField: UIViewRepresentable {
    @Binding private var text: String
    var digits: Int

    init(digits: Int, text: Binding<String>) {
        self._text = text
        self.digits = digits
    }

    func makeUIView(context: Context) -> SingleDigitTextFieldView {
        SingleDigitTextFieldView(digits: digits, text: $text)
    }

    func updateUIView(_ uiView: SingleDigitTextFieldView, context: Context) { }
}

class SingleDigitTextField: UITextField {
    weak var pinDelegate: SingleDigitTextFieldDelegate?

    override func deleteBackward() {
        pinDelegate?.didDeleteBackward(self)
        super.deleteBackward()
    }

    override func paste(_ sender: Any?) {
        pinDelegate?.willPastePIN()
        super.paste(sender)
    }
}

class SingleDigitTextFieldView: UIView {
    @Binding var text: String

    override func becomeFirstResponder() -> Bool {
        textFields[safe: activeTextFieldPosition]?.becomeFirstResponder() ?? false
    }

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let textFields: [SingleDigitTextField]
    private var activeTextFieldPosition: Int = -1
    private var digits: [String]
    private var isPastingPIN = false

    init(digits: Int, text: Binding<String>) {
        textFields = (0..<digits).map { _ in SingleDigitTextField() }
        self.digits = [String](repeating: "", count: digits)
        self._text = text
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        setupViews()
        setupLayout()
        activateNextTextField()
    }

    private func setupViews() {
        textFields.forEach {
            $0.textAlignment = .center
            $0.keyboardType = .numberPad
            $0.delegate = self
            $0.pinDelegate = self
            $0.addTarget(self, action: #selector(handleEditingChanged), for: .editingChanged)
            $0.tag = textFields.firstIndex(of: $0)! // swiftlint:disable:this force_unwrapping
            $0.layer.cornerRadius = 8
            $0.layer.borderWidth = 1
            $0.layer.borderColor = Color.genericGrey.cgColor
        }
    }

    private func setupLayout() {
        addSubview(stackView)

        stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        stackView.leftAnchor.constraint(greaterThanOrEqualTo: self.leftAnchor).isActive = true
        stackView.rightAnchor.constraint(lessThanOrEqualTo: self.rightAnchor).isActive = true

        textFields.forEach {
            stackView.addArrangedSubview($0)

            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.heightAnchor.constraint(equalToConstant: 48).isActive = true
            $0.widthAnchor.constraint(equalToConstant: 48).isActive = true
        }
    }

    @objc
    private func handleEditingChanged(textField: UITextField) {
        let oldDigit = digit(for: activeTextFieldPosition)
        let newDigit = textField.text ?? ""
        updateDigits(with: newDigit)

        // Dont activate previous textField if
        // current textField isn't the last one with a valid value
        if newDigit.isEmpty {
            guard oldDigit.isEmpty else { return }
            activatePreviousTextField()
        } else {
            activateNextTextField()
        }
    }

    private func updateDigits(with value: String) {
        digits[activeTextFieldPosition] = value
        updatePIN()
    }

    private func updatePIN() {
        let newPIN = digits.filter { !$0.isEmpty }.joined()
        self.text = newPIN
    }

    private func digit(for index: Int) -> String {
        digits[index]
    }

    private func activateNextTextField() {
        guard activeTextFieldPosition != textFields.count - 1 else { return }
        textFields[safe: activeTextFieldPosition + 1]?.becomeFirstResponder()
    }

    private func activatePreviousTextField() {
        guard activeTextFieldPosition != 0 else { return }
        textFields[safe: activeTextFieldPosition - 1]?.becomeFirstResponder()
    }

    private func pastePIN(_ pin: String) {
        guard (1...digits.count).contains(pin.count), Int(pin) != nil else { return }
        for (index, digit) in pin.enumerated() {
            let digitString = String(digit)
            digits[index] = digitString
            textFields[index].text = digitString
        }
        updatePIN()
    }
}

extension SingleDigitTextFieldView: UITextFieldDelegate, SingleDigitTextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = Color.primaryTint.cgColor
        activeTextFieldPosition = textField.tag
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = Color.genericGrey.cgColor
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if isPastingPIN {
            isPastingPIN = false
            pastePIN(string)
            return false
        }

        let isEmpty = textField.text?.isEmpty ?? true

        if !isEmpty && !string.isEmpty {
            textField.text = string
            handleEditingChanged(textField: textField)
        }

        return isEmpty || string.isEmpty
    }

    func didDeleteBackward(_ textField: SingleDigitTextField) {
        guard textField.text?.isEmpty == true else { return }
        handleEditingChanged(textField: textField)
    }

    func willPastePIN() {
        isPastingPIN = true
    }
}
