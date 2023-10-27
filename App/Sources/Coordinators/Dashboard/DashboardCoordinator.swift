import Domain
import JamitFoundation
import JLCoordinator
import MapKit
import PACECloudSDK
import UIKit

final class DashboardCoordinator: Coordinator {
    typealias Callback = () -> Void

    private let callback: Callback
    private let appStateInteractor: AppStateInteractor
    private let gasStationListInteractor: GasStationListInteractor
    private lazy var dashboardViewController: DashboardViewController = .instantiate()
    private lazy var navigationController: UINavigationController = .init(rootViewController: dashboardViewController)
    private lazy var menuGestureRecognizer: UIScreenEdgePanGestureRecognizer = .init(
        target: self,
        action: #selector(presentMenu)
    )

    private lazy var menuCoordinator: MenuCoordinator = .init(
        userInteractor: UserInteractor(repository: PACECloudUserRepository()),
        presenter: SidebarPresenter(
            interactionGestureRecognizer: menuGestureRecognizer,
            presentingViewController: dashboardViewController
        )
    )

    private var stations: [Domain.GasStation] = [] {
        didSet { updateDashboardViewModel() }
    }

    private var stationsByDistance: [Domain.GasStation] {
        return stations.sorted { lhs, rhs in
            switch (lhs.distanceInKilometers, rhs.distanceInKilometers) {
            case let (.some(lhsDistance), .some(rhsDistance)):
                return lhsDistance < rhsDistance

            case (.none, .some):
                return false

            default:
                return true
            }
        }
    }

    init(
        appStateInteractor: AppStateInteractor,
        gasStationListInteractor: GasStationListInteractor,
        presenter: Presenter,
        callback: @escaping Callback
    ) {
        self.appStateInteractor = appStateInteractor
        self.gasStationListInteractor = gasStationListInteractor
        self.callback = callback

        super.init(presenter: presenter)
    }

    override func start() {
        dashboardViewController.delegate = self
        dashboardViewController.navigationItem.leftBarButtonItems = [
            .init(image: Asset.Images.menu.image, style: .plain, target: self, action: #selector(presentMenu))
        ]

        menuGestureRecognizer.edges = .left
        dashboardViewController.view.addGestureRecognizer(menuGestureRecognizer)

        presenter.present(navigationController, animated: true)

        dashboardViewController.model.isLoading = dashboardViewController.model.rows.isEmpty
        gasStationListInteractor.startGasStationUpdates { [weak self] result in
            switch result {
            case let .success(stations):
                self?.stations = stations

            case .failure(CLError.denied):
                self?.presentLocationPremissionAlert()

            case let .failure(error):
                print(error)
            }

            self?.dashboardViewController.model.isLoading = false
        }
    }

    private func fetchGasStations(_ completion: (() -> Void)? = nil) {
        dashboardViewController.model.isLoading = dashboardViewController.model.rows.isEmpty
        gasStationListInteractor.fetchGasStations { [weak self] result in
            switch result {
            case let .success(stations):
                self?.stations = stations

            case .failure(CLError.denied):
                self?.presentLocationPremissionAlert()

            case let .failure(error):
                print(error)
            }

            self?.dashboardViewController.model.isLoading = false
            completion?()
        }
    }
}

// MARK: - Flow
extension DashboardCoordinator {
    @objc
    private func presentMenu() {
        if menuCoordinator.parentCoordinator == nil {
            menuCoordinator.delegate = self
            add(childCoordinator: menuCoordinator)
        }

        if !menuCoordinator.isPresenting {
            menuCoordinator.start()
        }
    }

    private func presentLocationPremissionAlert() {
        let alert = UIAlertController(
            title: L10n.Alert.LocationPermission.title,
            message: L10n.Alert.LocationPermission.description,
            preferredStyle: .alert
        )

        alert.addAction(
            UIAlertAction(title: L10n.Alert.LocationPermission.Actions.openSettings, style: .default) { [weak self] _ in
                self?.openSettingsApplication()
            }
        )

        dashboardViewController.present(alert, animated: true, completion: nil)
    }

    private func openSettingsApplication() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }

        UIApplication.shared.open(url)
    }

    private func openNavigation(to station: Domain.GasStation) {
        guard let location = station.location else { return }

        let item = MKMapItem(
            placemark: MKPlacemark(coordinate: .init(latitude: location.latitude, longitude: location.longitude))
        )
        item.name = station.name
        item.openInMaps(launchOptions: nil)
    }

    private func startFueling(at station: Domain.GasStation) {
        let viewController = AppKit.appViewController(
            presetUrl: .fueling(id: station.identifier)
        )
        dashboardViewController.present(viewController, animated: true, completion: nil)
    }
}

// MARK: - MenuCoordinatorDelegate
extension DashboardCoordinator: MenuCoordinatorDelegate {
    func didTriggerAction(_ action: MenuCoordinator.Action, in coordinator: MenuCoordinator) {
        switch action {
        case .openImprint:
            openImprint()

        case .openPrivacyPolicy:
            openPrivacyPolicy()

        case .openFuelTypeSelection:
            openFuelTypeSelection()

        case .openPaymentMethods:
            openPaymentMethods()

        case .openPaymentHistory:
            openPaymentHistory()

        case .logout:
            showLogoutConfirmation()
        }
    }

    func openImprint() {
        let coordinator = DocumentCoordinator(
            document: .imprint,
            presenter: ModalPresenter(presentingViewController: dashboardViewController)
        )
        add(childCoordinator: coordinator)
        coordinator.start()
    }

    func openPrivacyPolicy() {
        let coordinator = DocumentCoordinator(
            document: .privacy,
            presenter: ModalPresenter(presentingViewController: dashboardViewController)
        )
        add(childCoordinator: coordinator)
        coordinator.start()
    }

    func openFuelTypeSelection() {
        gasStationListInteractor.getFuelType { [weak self] result in
            guard let self = self else { return }

            let selectedFuelType: Domain.FuelType?
            switch result {
            case let .success(fuelType):
                selectedFuelType = fuelType

            default:
                selectedFuelType = nil
            }

            let coordinator = FuelTypeCoordinator(
                gasStationListInteractor: self.gasStationListInteractor,
                presenter: ModalPresenter(presentingViewController: self.dashboardViewController),
                isCompact: true,
                selectedFuelType: selectedFuelType
            ) { [weak self] in
                self?.fetchGasStations()
            }

            self.add(childCoordinator: coordinator)
            coordinator.start()
        }
    }

    func openPaymentMethods() {
        let coordinator = PaymentMethodCoordinator(
            presenter: ModalPresenter(presentingViewController: dashboardViewController)
        )
        add(childCoordinator: coordinator)
        coordinator.start()
    }

    func openPaymentHistory() {
        let coordinator = PaymentHistoryCoordinator(
            presenter: ModalPresenter(presentingViewController: dashboardViewController)
        )
        add(childCoordinator: coordinator)
        coordinator.start()
    }

    func showLogoutConfirmation() {
        let alertController = UIAlertController(
            title: L10n.Dashboard.Logout.Confirm.title,
            message: L10n.Dashboard.Logout.Confirm.description,
            preferredStyle: .alert
        )

        alertController.addAction(
            UIAlertAction(
                title: L10n.Dashboard.Logout.Confirm.Action.logout,
                style: .default
            ) { [weak self] _ in
                self?.logout()
            }
        )

        alertController.addAction(
            UIAlertAction(
                title: L10n.Dashboard.Logout.Confirm.Action.cancel,
                style: .cancel,
                handler: nil
            )
        )

        dashboardViewController.present(alertController, animated: true, completion: nil)
    }

    private func logout() {
        appStateInteractor.setOnboardingCompleted(false) { [weak self] _ in
            IDKit.resetSession { result in
                switch result {
                case .success:
                    DispatchQueue.main.async {
                        self?.callback()
                    }

                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}

// MARK: - Model Mapping
extension DashboardCoordinator {
    private func updateDashboardViewModel() {
        dashboardViewController.model.rows.removeAll(keepingCapacity: true)

        guard !stationsByDistance.isEmpty else { return }

        if let nearestStation = stationsByDistance.first {
            dashboardViewController.model.rows.append(contentsOf: [
                .header(DashboardHeaderViewModel(title: L10n.Dashboard.Sections.nearestGasStation)),
                .item(makeGasStationItemViewModel(for: nearestStation))
            ])
        }

        guard stationsByDistance.count > 1 else { return }

        dashboardViewController.model.rows.append(
            .header(DashboardHeaderViewModel(title: L10n.Dashboard.Sections.otherGasStations))
        )

        dashboardViewController.model.rows.append(contentsOf: stationsByDistance.suffix(from: 1).map { station in
            .item(makeGasStationItemViewModel(for: station))
        })
    }

    private func makeGasStationItemViewModel(for station: Domain.GasStation) -> DashboardItemViewModel {
        return .init(
            icon: Asset.Images.gasStationLogo.image,
            title: station.name,
            description: station.addressLines.joined(separator: "\n"),
            price: station.fuelPrice?.value,
            fuelType: station.fuelType,
            currency: station.fuelPrice?.currency,
            distance: Double(station.distanceInKilometers ?? 0),
            isPrimaryAction: station.isFuelingEnabled,
            action: makeActionViewModel(for: station)
        )
    }

    private func makeActionViewModel(for station: Domain.GasStation) -> ButtonViewModel {
        if station.isFuelingEnabled {
            return ButtonViewModel(
                title: L10n.Dashboard.Actions.startFueling
            ) { [weak self] in
                self?.startFueling(at: station)
            }
        }

        return ButtonViewModel(
            title: L10n.Dashboard.Actions.navigate
        ) { [weak self] in
            self?.openNavigation(to: station)
        }
    }
}

// MARK: - DashboardViewControllerDelegate
extension DashboardCoordinator: DashboardViewControllerDelegate {
    func didTriggerRefreshAction(_ completion: @escaping () -> Void) {
        fetchGasStations(completion)
    }
}
