import Foundation
import CoreLocation

public final class GasStationListInteractor {
    public typealias GasStationUpdateCallback = (Result<[GasStation], Error>) -> Void

    private let gasStationListRepository: GasStationListRepository
    private let locationRepository: LocationRepository
    private let updateDistanceThresholdInMeters: Double
    private var updateCallbacks: [GasStationUpdateCallback] = []
    private var lastUpdateLocation: Location?
    private var currentLocation: Location? {
        didSet { updateGasStations() }
    }
    private var locationError: Error? {
        didSet { updateGasStations() }
    }

    public init(
        gasStationListRepository: GasStationListRepository,
        locationRepository: LocationRepository,
        updateDistanceThresholdInMeters: Double
    ) {
        self.gasStationListRepository = gasStationListRepository
        self.locationRepository = locationRepository
        self.updateDistanceThresholdInMeters = updateDistanceThresholdInMeters
        self.currentLocation = locationRepository.currentLocation
    }

    public func getFuelType(_ completion: @escaping (Result<FuelType?, Error>) -> Void) {
        gasStationListRepository.getFuelType(completion)
    }

    public func setFuelType(_ fuelType: FuelType, _ completion: @escaping (Result<Bool, Error>) -> Void) {
        gasStationListRepository.setFuelType(fuelType, completion)
    }

    public func startGasStationUpdates(_ callback: @escaping GasStationUpdateCallback) {
        updateCallbacks.append(callback)
        locationRepository.startLocationUpdates { [weak self] result in
            switch result {
            case .success(let location):
                self?.currentLocation = location
                self?.locationError = nil
                break

            case .failure(let error):
                self?.currentLocation = nil
                self?.locationError = error
                break
            }
        }
    }

    public func stopGasStationUpdates() {
        locationRepository.stopLocationUpdates()
        updateCallbacks.removeAll()
    }

    public func fetchGasStations(_ callback: @escaping GasStationUpdateCallback) {
        lastUpdateLocation = nil
        updateGasStations(callback)
    }


    private func updateGasStations(_ callback: GasStationUpdateCallback? = nil) {
        if let locationError = locationError {
            lastUpdateLocation = nil
            updateCallbacks.forEach { $0(.failure(locationError)) }
            callback?(.failure(locationError))
            return
        }

        guard let currentLocation = currentLocation else { return }

        let isUpdateRequired = lastUpdateLocation.flatMap { $0.distance(to: currentLocation) >= updateDistanceThresholdInMeters } ?? true

        guard isUpdateRequired else { return }

        lastUpdateLocation = currentLocation
        gasStationListRepository.fetchGasStations(at: currentLocation) { [weak self] result in
            self?.updateCallbacks.forEach { $0(result) }
            callback?(result)
        }
    }
}
