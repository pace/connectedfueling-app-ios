import CoreLocation
import Foundation

protocol LocationManagerDelegate: AnyObject {
    func didUpdateLocations(locations: [CLLocation])
    func didFail(with error: Error)
}

class LocationManager: NSObject {
    enum LocationPermissionStatus {
        case notDetermined
        case denied
        case authorized
    }

    weak var delegate: LocationManagerDelegate?

    private let locationManager: CLLocationManager

    private var locationPermissionCallback: ((LocationPermissionStatus) -> Void)?

    init(locationManager: CLLocationManager = .init()) {
        self.locationManager = locationManager

        super.init()

        self.locationManager.delegate = self
    }

    func currentLocationPermissionStatus() async -> LocationPermissionStatus {
        let status = locationManager.authorizationStatus
        let mappedStatus = makeLocationPermissionStatus(for: status)
        return mappedStatus
    }

    func requestLocationPermission(completion: @escaping (LocationPermissionStatus) -> Void) {
        self.locationPermissionCallback = completion

        let status = locationManager.authorizationStatus

        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()

        default:
            break
        }
    }

    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }

    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
}

private extension LocationManager {
    func makeLocationPermissionStatus(for authorizationStatus: CLAuthorizationStatus) -> LocationPermissionStatus {
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

extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let newStatus = makeLocationPermissionStatus(for: manager.authorizationStatus)
        locationPermissionCallback?(newStatus)
        locationPermissionCallback = nil
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        delegate?.didUpdateLocations(locations: locations)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        delegate?.didFail(with: error)
    }
}
