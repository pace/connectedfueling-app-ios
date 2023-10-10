import Foundation
import CoreLocation

public protocol LocationRepository {
    typealias LocationPermissionCallback = (Result<Domain.LocationPermissionStatus, Error>) -> Void
    typealias LocationUpdateCallback = (Result<Location, Error>) -> Void

    var currentLocation: Location? { get }

    func fetchLocationPermissionStatus(_ completion: @escaping LocationPermissionCallback)

    func requestLocationPermission(_ completion: @escaping LocationPermissionCallback)

    func startLocationUpdates(_ callback: @escaping LocationUpdateCallback)

    func stopLocationUpdates()
}
