import JamitFoundation
import UIKit

final class InputViewController: CofuViewController<InputViewModel> {
    private lazy var titleLabel: Label = {
        let label: Label = .instantiate()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var descriptionLabel: Label = {
        let label: Label = .instantiate()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var errorLabel: Label = {
        let label: Label = .instantiate()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var inputField: UITextField = {
        let textField: UITextField = .instantiate()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var textFieldBottomLine: UIView = {
        let view: UIView = .instantiate()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()

    private lazy var confirmButton: ButtonView = {
        let buttonView: ButtonView = .instantiate()
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        return buttonView
    }()

    var style: InputViewStyle = .default {
        didSet { didChangeStyle() }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        inputField.isSecureTextEntry = true
        inputField.keyboardType = .numberPad
        inputField.addTarget(self, action: #selector(didChangeInputValue), for: .editingChanged)

        confirmButton.model = .init(isEnabled: false) { [weak self] in
            self?.didTriggerSubmitAction()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        inputField.text = nil
        inputField.becomeFirstResponder()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        inputField.resignFirstResponder()
    }

    override func didChangeModel() {
        super.didChangeModel()

        titleLabel.text = model.title
        descriptionLabel.text = model.description
        errorLabel.text = model.error
        confirmButton.model.title = model.submitTitle
        confirmButton.model.isEnabled = model.isConfirmButtonEnabled
    }

    override func setup() {
        super.setup()

        [
            titleLabel,
            descriptionLabel,
            errorLabel,
            inputField,
            textFieldBottomLine,
            confirmButton
        ].forEach(view.addSubview)

        titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -25).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true

        descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 60).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -60).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50).isActive = true

        inputField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 60).isActive = true
        inputField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -60).isActive = true
        inputField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20).isActive = true
        inputField.heightAnchor.constraint(equalToConstant: 40).isActive = true

        textFieldBottomLine.leadingAnchor.constraint(equalTo: inputField.leadingAnchor).isActive = true
        textFieldBottomLine.trailingAnchor.constraint(equalTo: inputField.trailingAnchor).isActive = true
        textFieldBottomLine.bottomAnchor.constraint(equalTo: inputField.bottomAnchor).isActive = true
        textFieldBottomLine.heightAnchor.constraint(equalToConstant: 1).isActive = true

        errorLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 60).isActive = true
        errorLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -60).isActive = true
        errorLabel.topAnchor.constraint(equalTo: textFieldBottomLine.bottomAnchor).isActive = true

        confirmButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25).isActive = true
        confirmButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -25).isActive = true
        confirmButton.topAnchor.constraint(equalTo: inputField.bottomAnchor, constant: 50).isActive = true
        confirmButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

    private func didChangeStyle() {
        view.backgroundColor = style.background
        inputField.textColor = style.inputFieldTextColor
        textFieldBottomLine.backgroundColor = style.bottomLineColor
        titleLabel.style = style.titleStyle
        descriptionLabel.style = style.descriptionStyle
        errorLabel.style = style.errorStyle
    }
}

// MARK: - Actions
extension InputViewController {
    @objc
    private func didChangeInputValue() {
        model.onValidate(inputField.text)
    }

    private func didTriggerSubmitAction() {
        model.onSubmit(inputField.text ?? "")
    }
}
