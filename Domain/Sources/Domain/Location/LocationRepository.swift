import Foundation

public protocol LocationRepository {
    typealias LocationPermissionCallback = (Result<LocationPermissionStatus, Error>) -> Void
    typealias LocationUpdateCallback = (Result<Location, Error>) -> Void

    var defaultLocation: Location { get }

    func fetchLocationPermissionStatus(_ completion: @escaping LocationPermissionCallback)

    func requestLocationPermission(_ completion: @escaping LocationPermissionCallback)

    func startLocationUpdates(_ callback: @escaping LocationUpdateCallback)

    func stopLocationUpdates()
}
