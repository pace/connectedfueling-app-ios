import Domain
import JLCoordinator
import UIKit

final class AppCoordinator: Coordinator {
    private lazy var appStateRepository: AppStateRepository = UserDefaultAppStateRepository()
    private lazy var appStateInteractor: AppStateInteractor = .init(appStateRepository: appStateRepository)
    private lazy var authenticationInteracotr: AuthenticationInteractor = .init(
        authenticationRepository: PACECloudAuthenticationRepository(presentingViewController: nil)
    )

    private lazy var locationRepository: LocationRepository = CoreLocationRepository()

    private lazy var gasStationListInteractor: GasStationListInteractor = .init(
        gasStationListRepository: PACECloudGasStationListRepository(
            poiKitManager: .init(environment: .sandbox)
        ),
        locationRepository: locationRepository,
        updateDistanceThresholdInMeters: 500
    )

    private lazy var paymentInteractor: PaymentInteractor = .init(
        paymentRepository: PACECloudPaymentRepository()
    )

    override func start() {
        presentCoordinator()
    }

    private func presentCoordinator() {
        authenticationInteracotr.isAuthenticated { [weak self] authenticationResult in
            self?.appStateInteractor.isOnboardingCompleted { [weak self] result in
                if
                    case .success(true) = result,
                    case .success(true) = authenticationResult
                {
                    self?.startDashboardCoordinator()
                } else {
                    self?.startOnboardingCoordinator()
                }
            }
        }
    }
}

// MARK: - Coordination
extension AppCoordinator {
    private func startOnboardingCoordinator() {
        let coordinator = OnboardingCoordinator(
            locationRepository: locationRepository,
            gasStationListInteractor: gasStationListInteractor,
            paymentInteractor: paymentInteractor,
            presenter: presenter
        ) { [weak self] in
            self?.appStateInteractor.setOnboardingCompleted(true) { _ in
                self?.startDashboardCoordinator()
            }
        }

        add(childCoordinator: coordinator)
        coordinator.start()
    }

    private func startDashboardCoordinator() {
        let coordinator = DashboardCoordinator(
            appStateInteractor: appStateInteractor,
            gasStationListInteractor: gasStationListInteractor,
            presenter: presenter
        ) { [weak self] in
            self?.presentCoordinator()
        }
        add(childCoordinator: coordinator)
        coordinator.start()
    }
}
