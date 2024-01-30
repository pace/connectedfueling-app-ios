import CoreLocation
import Foundation

protocol LocationManagerDelegate: AnyObject {
    func didUpdateLocations(locations: [CLLocation])
    func didFail(with error: Error)
}

class LocationManager: NSObject {
    static let shared: LocationManager = .init()

    private var delegates: [Delegate] = []

    private let locationManager: CLLocationManager
    private var locationPermissionCallback: ((PermissionStatus) -> Void)?

    private var latestLocations: [CLLocation] = []

    private override init() {
        self.locationManager = .init()

        super.init()

        self.locationManager.delegate = self
    }

    func subscribe(_ subscriber: LocationManagerDelegate) {
        guard !delegates.contains(where: { $0.receiver === subscriber }) else { return }

        let delegate: Delegate = .init(receiver: subscriber)
        delegates.append(delegate)
        delegate.receiver?.didUpdateLocations(locations: latestLocations)
    }

    func unsubscribe(_ subscriber: LocationManagerDelegate) {
        delegates.removeAll(where: { $0.receiver === subscriber })
    }

    func currentLocationPermissionStatus() async -> PermissionStatus {
        let status = locationManager.authorizationStatus
        let mappedStatus = makeLocationPermissionStatus(for: status)
        return mappedStatus
    }

    func requestLocationPermission(completion: @escaping (PermissionStatus) -> Void) {
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
}

private extension LocationManager {
    func makeLocationPermissionStatus(for authorizationStatus: CLAuthorizationStatus) -> PermissionStatus {
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
        latestLocations = locations
        delegates.forEach { $0.receiver?.didUpdateLocations(locations: locations) }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        delegates.forEach { $0.receiver?.didFail(with: error) }
    }
}

private extension LocationManager {
    class Delegate {
        weak var receiver: LocationManagerDelegate?

        init(receiver: LocationManagerDelegate) {
            self.receiver = receiver
        }
    }
}
