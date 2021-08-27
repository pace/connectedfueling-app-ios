import JamitFoundation
import UIKit

final class InputViewController: StatefulViewController<InputViewModel> {
    @IBOutlet private var titleLabel: Label!
    @IBOutlet private var descriptionLabel: Label!
    @IBOutlet private var errorLabel: Label!
    @IBOutlet private var inputField: UITextField!
    @IBOutlet private var confirmButtonContainer: UIView!

    private lazy var confirmButton: ButtonView = .instantiate()

    var style: InputViewStyle = .default {
        didSet { didChangeStyle() }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        inputField.isSecureTextEntry = true
        inputField.keyboardType = .numberPad

        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButtonContainer.addSubview(confirmButton)
        confirmButton.topAnchor.constraint(equalTo: confirmButtonContainer.topAnchor).isActive = true
        confirmButton.leadingAnchor.constraint(equalTo: confirmButtonContainer.leadingAnchor).isActive = true
        confirmButton.trailingAnchor.constraint(equalTo: confirmButtonContainer.trailingAnchor).isActive = true
        confirmButton.bottomAnchor.constraint(equalTo: confirmButtonContainer.bottomAnchor).isActive = true
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

    private func didChangeStyle() {
        titleLabel.style = style.titleStyle
        descriptionLabel.style = style.descriptionStyle
        errorLabel.style = style.errorStyle
    }
}

// MARK: - Actions
extension InputViewController {
    @IBAction private func didChangeInputValue() {
        model.onValidate(inputField.text)
    }

    private func didTriggerSubmitAction() {
        model.onSubmit(inputField.text ?? "")
    }
}
