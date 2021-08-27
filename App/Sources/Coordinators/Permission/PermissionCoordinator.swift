import Domain
import JLCoordinator
import UIKit

final class PermissionCoordinator: Coordinator {
    typealias Callback = () -> Void

    private let callback: Callback
    private var interactor: PermissionInteractor

    private lazy var viewController: OnboardingViewController = .instantiate()

    init(
        locationRepository: LocationRepository,
        presenter: Presenter,
        callback: @escaping Callback
    ) {
        self.callback = callback
        self.interactor = .init(locationRepository: locationRepository)

        super.init(presenter: presenter)
    }

    override func start() {
        viewController.model = .init(
            image: Asset.Images.location.image,
            title: L10n.Onboarding.Permission.title,
            description: L10n.Onboarding.Permission.description,
            actions: [
                .init(title: L10n.Onboarding.Actions.shareLocation) { [weak self] in
                    self?.presentLocationPermissionRequest()
                }
            ]
        )

        presenter.present(viewController, animated: true)

        viewController.model.isLoading = true
        interactor.fetchLocationPermissionStatus { [weak self] result in
            self?.viewController.model.isLoading = false

            if case .success(.authorized) = result {
                self?.callback()
            }
        }
    }

    private func presentLocationPermissionRequest() {
        interactor.requestLocationPermission { [weak self] _ in
            self?.callback()
        }
    }
}
