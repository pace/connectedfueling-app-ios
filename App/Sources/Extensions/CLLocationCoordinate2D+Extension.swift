import CoreLocation

public extension CLLocationCoordinate2D {
    // distance in meters
    func distance(from: CLLocationCoordinate2D) -> CLLocationDistance {
        let destination = CLLocation(latitude: from.latitude, longitude: from.longitude)

        return CLLocation(latitude: latitude, longitude: longitude).distance(from: destination)
    }
}
