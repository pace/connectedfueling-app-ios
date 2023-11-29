import Domain
import JLCoordinator
import UIKit

final class CreatePinCoordinator: Coordinator {
    typealias Callback = (Bool) -> Void

    private let callback: Callback

    private lazy var createPinViewController: InputViewController = .instantiate()
    private lazy var verifyPinViewController: InputViewController = .instantiate()
    private lazy var oneTimePasswordViewController: InputViewController = .instantiate()
    private lazy var navigationController: UINavigationController = .init(rootViewController: createPinViewController)

    private let interactor: TwoFactorAuthenticationInteractor

    required init(presenter: Presenter, interactor: TwoFactorAuthenticationInteractor, callback: @escaping Callback) {
        self.interactor = interactor
        self.callback = callback

        super.init(presenter: presenter)
    }

    override func start() {
        presentCreatePinViewController()
    }

    private func presentCreatePinViewController() {
        createPinViewController.style = .default
        createPinViewController.model = .init(
            title: "L10n.Onboarding.CreatePin.title",
            description: "L10n.Onboarding.CreatePin.description",
            submitTitle: "L10n.Onboarding.CreatePin.confirm",
            onValidate: { [weak createPinViewController] input in
                switch PinInputValidator.validate(input: input) {
                case let .failure(error):
                    createPinViewController?.model.error = error.localizedDescription
                    createPinViewController?.model.isConfirmButtonEnabled = false

                default:
                    createPinViewController?.model.error = nil
                    createPinViewController?.model.isConfirmButtonEnabled = true
                }
            },
            onSubmit: { [weak self] input in
                self?.presentVerifyPinViewController(pin: input)
            }
        )

        createPinViewController.navigationItem.leftBarButtonItems = [
            .init(title: L10n.Global.Actions.close, style: .plain, target: self, action: #selector(didCancelAuthentication))
        ]

        presenter.present(navigationController, animated: true)
    }

    private func presentVerifyPinViewController(pin: String) {
        verifyPinViewController.style = .default
        verifyPinViewController.model = .init(
            title: "L10n.Onboarding.VerifyPin.title",
            description: "L10n.Onboarding.VerifyPin.description",
            submitTitle: "L10n.Onboarding.VerifyPin.confirm",
            onValidate: { [weak verifyPinViewController] input in
                let isInputValid = input == pin
                verifyPinViewController?.model.isConfirmButtonEnabled = isInputValid
                verifyPinViewController?.model.error = isInputValid ? nil : "L10n.Onboarding.Pin.Error.mismatch"
            },
            onSubmit: { [weak self] pin in
                self?.requestOneTimePassword(withPin: pin)
            }
        )

        navigationController.pushViewController(verifyPinViewController, animated: true)
    }

    private func presentOneTimePasswordInputViewController(pin: String) {
        oneTimePasswordViewController.style = .default
        oneTimePasswordViewController.model = .init(
            title: "L10n.Onboarding.EnterOneTimePassword.title",
            description: "L10n.Onboarding.EnterOneTimePassword.description",
            submitTitle: "L10n.Onboarding.EnterOneTimePassword.confirm",
            onValidate: { [weak oneTimePasswordViewController] input in
                switch EmptyInputValidator.validate(input: input) {
                case .success:
                    oneTimePasswordViewController?.model.isConfirmButtonEnabled = true

                default:
                    oneTimePasswordViewController?.model.isConfirmButtonEnabled = false
                }
            },
            onSubmit: { [weak self] otp in
                self?.oneTimePasswordViewController.model.error = nil
                self?.enablePinAuthentication(pin: pin, otp: otp)
            }
        )

        navigationController.pushViewController(oneTimePasswordViewController, animated: true)
    }

    private func requestOneTimePassword(withPin pin: String) {
        verifyPinViewController.model.error = nil
        interactor.requestOneTimePassword { [weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self?.presentOneTimePasswordInputViewController(pin: pin)
                }

            case let .failure(error):
                DispatchQueue.main.async { [weak self] in
                    self?.verifyPinViewController.model.error = String(describing: error)
                }
            }
        }
    }

    private func enablePinAuthentication(pin: String, otp: String) {
        interactor.enablePinAuthentication(pin: pin, otp: otp) { [weak self] result in
            switch result {
            case let .success(isPinSet):
                DispatchQueue.main.async {
                    self?.callback(isPinSet)
                    self?.presenter.dismissRoot(animated: true)
                    self?.stop()
                }

            case let .failure(error):
                DispatchQueue.main.async { [weak self] in
                    self?.oneTimePasswordViewController.model.error = String(describing: error)
                }
            }
        }
    }
}

// MARK: - Actions
extension CreatePinCoordinator {
    @objc
    private func didCancelAuthentication() {
        callback(false)
        presenter.dismissRoot(animated: true)
        stop()
    }
}
