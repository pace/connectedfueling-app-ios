import Domain
import JLCoordinator
import UIKit

final class TwoFactorAuthenticationCoordinator: Coordinator {
    typealias AuthenticationCallback = (Bool) -> Void

    private let callback: AuthenticationCallback
    private var configuredMethods: Set<TwoFactorAuthenticationMethod> = []
    private var availableMethods: Set<TwoFactorAuthenticationMethod> = [] {
        didSet { updateViewModel(with: availableMethods) }
    }

    private lazy var viewController: OnboardingViewController = .instantiate()
    private lazy var oneTimePasswordViewController: InputViewController = .instantiate()
    private lazy var oneTimePasswordNavigationController: UINavigationController = .init(
        rootViewController: oneTimePasswordViewController
    )

    private lazy var interactor: TwoFactorAuthenticationInteractor = .init(
        twoFactorAuthenticationRepository: PACECloudTwoFactorAuthenticationRepository()
    )

    required init(presenter: Presenter, callback: @escaping AuthenticationCallback) {
        self.callback = callback

        super.init(presenter: presenter)
    }

    override func start() {
        viewController.model = .init(
            image: Asset.Images.biometry.image,
            title: "L10n.Onboarding.TwoFactorAuthentication.title",
            description: "L10n.Onboarding.TwoFactorAuthentication.description"
        )

        presenter.present(viewController, animated: true)

        viewController.model.isLoading = true
        interactor.getConfiguredAuthenticationMethods { [weak self] result in
            switch result {
            case let .success(methods):
                self?.update(configuredMethods: methods)

            case let .failure(error):
                print(error)
            }
        }
    }

    private func update(configuredMethods methods: Set<TwoFactorAuthenticationMethod>) {
        configuredMethods = methods
        interactor.getAvailableAuthenticationMethods { [weak self] result in
            guard let self = self else { return }

            switch result {
            case let .success(methods):
                self.availableMethods = methods
                self.viewController.model.isLoading = false

                if self.availableMethods.subtracting(self.configuredMethods).isEmpty {
                    self.callback(true)
                }

            case let .failure(error):
                print(error)
            }
        }
    }

    private func updateViewModel(with methods: Set<TwoFactorAuthenticationMethod>) {
        let pinAction: ButtonViewModel = .init(title: "L10n.Onboarding.TwoFactorAuthentication.pin") { [weak self] in
            self?.requestAuthenticationWithPin()
        }

        if methods.contains(.biometry) {
            viewController.model.secondaryAction = pinAction
            viewController.model.action = .init(title: "L10n.Onboarding.TwoFactorAuthentication.biometry") { [weak self] in
                self?.requestAuthenticationWithBiometry()
            }
        } else {
            viewController.model.action = pinAction
        }
    }

    private func requestAuthenticationWithPin() {
        guard !configuredMethods.contains(.pin) else {
            DispatchQueue.main.async { [weak self] in
                self?.callback(true)
            }

            return
        }

        let coordinator = CreatePinCoordinator(
            presenter: ModalPresenter(presentingViewController: viewController),
            interactor: interactor
        ) { [weak self] success in
            self?.callback(success)
        }

        add(childCoordinator: coordinator)
        coordinator.start()
    }

    private func requestAuthenticationWithBiometry(otp: String? = nil) {
        guard !configuredMethods.contains(.biometry) else {
            DispatchQueue.main.async { [weak self] in
                self?.callback(true)
            }

            return
        }

        interactor.enableBiometricAuthentication(otp: otp) { [weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self?.callback(true)
                }

            case let .failure(error):
                print(error)

                guard otp == nil else {
                    DispatchQueue.main.async {
                        self?.callback(false)
                    }

                    return
                }

                self?.requestOneTimePasswordForBiometry()
            }
        }
    }

    private func requestOneTimePasswordForBiometry() {
        interactor.requestOneTimePassword { [weak self] result in
            switch result {
            case .success:
                self?.presentOneTimePasswordInputViewControllerForBiometry()

            case let .failure(error):
                print(error)

                DispatchQueue.main.async {
                    self?.callback(false)
                }
            }
        }
    }

    private func presentOneTimePasswordInputViewControllerForBiometry() {
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
                self?.oneTimePasswordNavigationController.dismiss(animated: true) {
                    self?.requestAuthenticationWithBiometry(otp: otp)
                }
            }
        )

        oneTimePasswordViewController.navigationItem.leftBarButtonItems = [
            .init(title: L10n.Global.Actions.close, style: .plain, target: self, action: #selector(didTriggerCancelAction))
        ]

        viewController.present(oneTimePasswordNavigationController, animated: true)
    }
}

// MARK: - Actions
extension TwoFactorAuthenticationCoordinator {
    @objc
    private func didTriggerCancelAction() {
        callback(false)
    }
}
