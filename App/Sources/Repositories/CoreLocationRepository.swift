import CoreLocation
import Domain

public enum CoreLocationRepositoryError: Error {
    case permissionNotGranted
}

final class CoreLocationRepository: NSObject, LocationRepository {
    let defaultLocation: Location

    private var locationManager: CLLocationManager
    private var locationPermissionCallbacks: [LocationPermissionCallback] = []
    private var isRequestingLocationPermission: Bool = false
    private var locationUpdateCallbacks: [LocationUpdateCallback] = []
    private var currentLocation: Location {
        didSet { didChangeCurrentLocation() }
    }

    init(
        defaultLocation: CLLocation,
        locationManager: CLLocationManager = .init()
    ) {
        self.defaultLocation = Location(
            longitude: defaultLocation.coordinate.longitude,
            latitude: defaultLocation.coordinate.latitude
        )
        self.locationManager = locationManager
        self.currentLocation = Location(
            longitude: defaultLocation.coordinate.longitude,
            latitude: defaultLocation.coordinate.latitude
        )
        super.init()

        self.locationManager.delegate = self
    }

    func fetchLocationPermissionStatus(_ completion: @escaping LocationPermissionCallback) {
        let status = CLLocationManager.authorizationStatus()
        completion(.success(makeLocationStatus(for: status)))
    }

    func requestLocationPermission(_ completion: @escaping LocationPermissionCallback) {
        guard !isRequestingLocationPermission else {
            locationPermissionCallbacks.append(completion)
            return
        }

        let status = CLLocationManager.authorizationStatus()

        switch status {
        case .notDetermined:
            locationPermissionCallbacks.append(completion)
            isRequestingLocationPermission = true
            locationManager.requestWhenInUseAuthorization()

        default:
            completion(.success(makeLocationStatus(for: status)))
        }
    }

    func startLocationUpdates(_ callback: @escaping LocationUpdateCallback) {
        locationUpdateCallbacks.append(callback)
        locationManager.startUpdatingLocation()
    }

    func stopLocationUpdates() {
        locationManager.stopUpdatingLocation()
        locationUpdateCallbacks.removeAll()
    }

    private func didChangeCurrentLocation() {
        locationUpdateCallbacks.forEach { callback in
            callback(.success(currentLocation))
        }
    }
}

// MARK: - Mapping
extension CoreLocationRepository {
    private func makeLocationStatus(for authorizationStatus: CLAuthorizationStatus) -> LocationPermissionStatus {
        switch authorizationStatus {
        case .notDetermined:
            return .notDetermined

        case .restricted, .denied:
            return .denied

        case .authorizedWhenInUse, .authorizedAlways:
            return .authorized

        @unknown default:
            return .denied
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension CoreLocationRepository: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationPermissionCallbacks.forEach { $0(.success(makeLocationStatus(for: status))) }
        locationPermissionCallbacks.removeAll()
        isRequestingLocationPermission = false
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        currentLocation = Location(longitude: location.coordinate.longitude, latitude: location.coordinate.latitude)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationUpdateCallbacks.forEach { callback in
            callback(.failure(error))
        }
    }
}
