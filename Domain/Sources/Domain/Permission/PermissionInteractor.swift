import Foundation
import CoreLocation

public final class PermissionInteractor {
    private let locationRepository: LocationRepository

    public init(locationRepository: LocationRepository) {
        self.locationRepository = locationRepository
    }

    public func fetchLocationPermissionStatus(_ completion: @escaping (Result<LocationPermissionStatus, Error>) -> Void) {
        locationRepository.fetchLocationPermissionStatus(completion)
    }

    public func requestLocationPermission(_ completion: @escaping (Result<Void, Error>) -> Void) {
        locationRepository.requestLocationPermission { _ in completion(.success(())) }
    }
}
