import CoreLocation
import PACECloudSDK
import SwiftUI

class GasStationListViewModel: ObservableObject {
    @Published var stations: [GasStation]?
    @Published var alert: Alert?

    private var currentLocation: CLLocation?
    private var previousLocation: CLLocation?

    private let poiManager: POIManager
    private let locationManager: LocationManager

    let style: ConfigurationManager.Configuration.GasStationListStyle

    init(configuration: ConfigurationManager.Configuration = ConfigurationManager.configuration,
         stations: [GasStation]? = nil,
         poiManager: POIManager = .init(),
         locationManager: LocationManager = .shared) {
        self.style = configuration.gasStationListStyle
        self.stations = stations
        self.poiManager = poiManager
        self.locationManager = locationManager

        self.locationManager.subscribe(self)
    }

    func viewWillAppear() {
        locationManager.startUpdatingLocation()
    }

    func reloadCofuStations() {
        guard let currentLocation = currentLocation else { return }
        fetchCofuStations(at: currentLocation)
    }

    private func fetchCofuStations(at location: CLLocation) {
        Task { @MainActor [weak self] in
            self?.alert = nil

            guard let result = await self?.poiManager.fetchCofuStations(at: location) else { return }

            switch result {
            case .success(let cofuStations):
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
    }

    private func handleError(_ error: Error) {
        switch error {
        case let poiKitError as POIKit.POIKitAPIError:
            switch poiKitError {
            case .operationCanceledByClient:
                break

            case .networkError:
                alert = AppAlert.networkError(retryAction: reloadCofuStations)

            default:
                alert = AppAlert.genericError
            }

        case let clError as CLError:
            guard clError.code == .denied else { break }
            alert = AppAlert.locationPermissionError

        default:
            alert = AppAlert.genericError
        }
    }
}

extension GasStationListViewModel: LocationManagerDelegate {
    func didUpdateLocations(locations: [CLLocation]) {
        guard let location = locations.last else { return }
        currentLocation = location

        let isUpdateRequired = previousLocation.flatMap { $0.distance(from: location) >= Constants.GasStation.updateDistanceThresholdInMeters } ?? true
        guard isUpdateRequired else { return }

        previousLocation = location
        fetchCofuStations(at: location)
    }

    func didFail(with error: Error) {
        guard let clError = error as? CLError, clError.code == .denied else { return }
        handleError(error)
    }
}
