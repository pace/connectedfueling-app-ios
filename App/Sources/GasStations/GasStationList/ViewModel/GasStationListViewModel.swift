import CoreLocation
import PACECloudSDK
import SwiftUI

class GasStationListViewModel: ObservableObject {
    @Published var stations: [GasStation]?
    @Published var error: AppError?
    @Published var noPaymentMethodError: AppError?
    @Published var selectedFuelingUrlString: String?

    private var currentLocation: CLLocation?
    private var previousLocation: CLLocation?

    private let poiManager: POIManager
    private let locationManager: LocationManager
    private let analyticsManager: AnalyticsManager
    private let paymentManager: PaymentManager

    let style: ConfigurationManager.Configuration.GasStationListStyle

    init(configuration: ConfigurationManager.Configuration = ConfigurationManager.configuration,
         stations: [GasStation]? = nil,
         poiManager: POIManager = .init(),
         analyticsManager: AnalyticsManager = .init(),
         locationManager: LocationManager = .shared,
         paymentManager: PaymentManager = .init()) {
        self.style = configuration.gasStationListStyle
        self.stations = stations
        self.poiManager = poiManager
        self.locationManager = locationManager
        self.analyticsManager = analyticsManager
        self.paymentManager = paymentManager

        self.locationManager.subscribe(self)
    }

    func viewWillAppear() {
        checkPaymentMethodAvailability()

        guard locationManager.currentLocationPermissionStatus == .authorized else {
            error = .locationError
            return
        }

        locationManager.startUpdatingLocation()
    }

    func reload() {
        checkPaymentMethodAvailability()
        reloadCofuStations()
    }

    private func reloadCofuStations() {
        guard let currentLocation = currentLocation else { return }
        fetchCofuStations(at: currentLocation)
    }

    private func fetchCofuStations(at location: CLLocation) {
        Task { @MainActor [weak self] in
            self?.error = nil

            guard let result = await self?.poiManager.fetchCofuStations(at: location) else { return }

            switch result {
            case .success(let cofuStations):
                if cofuStations.contains(where: { $0.isNearby }) {
                    self?.analyticsManager.logEvent(AnalyticEvents.StationNearbyEvent())
                }

                let sortedCofuStations = cofuStations.sorted()
                self?.updateSections(with: sortedCofuStations)

            case.failure(let error):
                CofuLogger.e("[GasStationListViewModel] Failed fetching cofu stations with error \(error)")
                self?.handleError(error)
            }
        }
    }

    private func updateSections(with cofuStations: [GasStation]) {
        self.stations = cofuStations
        if cofuStations.isEmpty {
            error = .emptyError
        } else {
            error = nil
        }
    }

    private func checkPaymentMethodAvailability() {
        Task { @MainActor [weak self] in
            let hasPaymentMethod = await self?.paymentManager.hasPaymentMethods()
            switch hasPaymentMethod {
            case .success(let paymentMethodsAvailable):
                if paymentMethodsAvailable {
                    self?.noPaymentMethodError = nil
                } else {
                    let nativeEnabled = await self?.paymentManager.isNativePaymentMethodOnboardingEnabled()
                    self?.noPaymentMethodError = .init(title: nativeEnabled == true ? L10n.paymentMethodsEmptyTitle : L10n.managedPaymentMethodsEmptyTitle,
                                                       description: nativeEnabled == true ? L10n.paymentMethodsEmptyDescription : L10n.managedPaymentMethodsEmptyDescription,
                                                       icon: .imageResource(.errorIcon))
                }
            case .failure(let error):
                CofuLogger.e("[GasStationListViewModel] Failed checking payment methods with error \(error)")
                self?.noPaymentMethodError = nil
            case .none:
                CofuLogger.e("[GasStationListViewModel] Failed checking payment methods with status .none")
                self?.noPaymentMethodError = nil
            }
        }
    }

    private func handleError(_ error: Error) {
        switch error {
        case let poiKitError as POIKit.POIKitAPIError:
            switch poiKitError {
            case .operationCanceledByClient:
                break

            case .networkError:
                self.error = generalError()

            default:
                self.error = generalError()
            }

        case let clError as CLError:
            guard clError.code == .denied else { break }
            self.error = AppError.locationError

        default:
            self.error = generalError()
        }
    }

    func generalError() -> AppError {
        .init(title: L10n.generalErrorTitle,
              description: L10n.Home.loadingFailedText,
              retryAction: .init(title: L10n.commonUseRetry,
                                 action: { [weak self] in
            self?.reload()
        }))
    }
}

extension GasStationListViewModel: LocationManagerDelegate {
    func didUpdateLocations(locations: [CLLocation]) {
        guard let location = locations.last else { return }
        currentLocation = location

        let isUpdateRequired = previousLocation.flatMap { $0.distance(from: location) >= Constants.GasStation.updateDistanceThresholdInMeters } ?? true
        guard isUpdateRequired || error != nil else { return }

        previousLocation = location
        fetchCofuStations(at: location)
    }

    func didFail(with error: Error) {
        guard let clError = error as? CLError, clError.code == .denied else { return }
        handleError(error)
    }

    func didChangePermissionStatus(newStatus: PermissionStatus) {}
}
