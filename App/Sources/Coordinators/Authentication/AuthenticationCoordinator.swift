import Domain
import JLCoordinator
import UIKit

final class AuthenticationCoordinator: Coordinator {
    typealias AuthenticationCallback = (Bool) -> Void

    private let presentingViewController: UIViewController
    private let callback: AuthenticationCallback

    private lazy var authenticationInteractor: AuthenticationInteractor = .init(
        authenticationRepository: PACECloudAuthenticationRepository(presentingViewController: presentingViewController)
    )
    private lazy var viewController: OnboardingViewController = .instantiate()

    required init(
        presenter: Presenter,
        modalPresenter: ModalPresenting,
        callback: @escaping AuthenticationCallback
    ) {
        self.presentingViewController = modalPresenter.presentingViewController
        self.callback = callback

        super.init(presenter: presenter)
    }

    override func start() {
        viewController.model = .init(
            image: Asset.Images.profile.image,
            title: L10n.Onboarding.Authentication.title,
            description: L10n.Onboarding.Authentication.description,
            action: .init(title: L10n.Onboarding.Actions.authenticate) { [weak self] in
                self?.requestAuthentication()
            }
        )

        presenter.present(viewController, animated: true)

        authenticationInteractor.isAuthenticated { [weak self] result in
            switch result {
            case let .success(isAuthenticated):
                if isAuthenticated {
                    self?.callback(true)
                }

            case .failure:
                self?.callback(false)
            }
        }
    }

    private func requestAuthentication() {
        authenticationInteractor.isAuthenticated { [weak self] result in
            switch result {
            case let .success(isAuthenticated):
                if !isAuthenticated {
                    self?.authenticate()
                } else {
                    self?.callback(true)
                }

            case .failure:
                self?.callback(false)
            }
        }
    }

    private func authenticate() {
        authenticationInteractor.authenticate { [weak self] result in
            switch result {
            case .success:
                self?.callback(true)

            case .failure:
                self?.callback(false)
            }
        }
    }
}
