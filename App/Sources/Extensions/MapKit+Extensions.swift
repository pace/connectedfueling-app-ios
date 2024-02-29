import MapKit
import PACECloudSDK

extension MKCoordinateSpan: Equatable {
    public static func == (lhs: MKCoordinateSpan, rhs: MKCoordinateSpan) -> Bool {
        lhs.latitudeDelta == rhs.latitudeDelta && lhs.longitudeDelta == rhs.longitudeDelta
    }
}

extension MKCoordinateRegion: Equatable {
    public static func == (lhs: MKCoordinateRegion, rhs: MKCoordinateRegion) -> Bool {
        lhs.center == rhs.center && lhs.span == rhs.span
    }
}

extension MKCoordinateRegion {
    public func visibleBoundingBox(with padding: Double = 0.0) -> POIKit.BoundingBox {
        let centerLatitude = clampLatitude(self.center.latitude)
        let centerLongitude = normalizeLongitude(self.center.longitude)

        let latitudeDelta = self.span.latitudeDelta
        let longitudeDelta = self.span.longitudeDelta

        let topLatitude = clampLatitude(centerLatitude + latitudeDelta / 2.0)
        let bottomLatitude = clampLatitude(centerLatitude - latitudeDelta / 2.0)

        let rightLongitude = normalizeLongitude(centerLongitude + longitudeDelta / 2.0)
        let leftLongitude = normalizeLongitude(centerLongitude - longitudeDelta / 2.0)

        return .init(point1: .init(latitude: topLatitude, longitude: rightLongitude), 
                     point2: .init(latitude: bottomLatitude, longitude: leftLongitude),
                     center: self.center, padding: padding)
    }

    private func clampLatitude(_ latitude: CLLocationDegrees) -> CLLocationDegrees {
        return max(min(latitude, 90.0), -90.0)
    }

    private func normalizeLongitude(_ longitude: CLLocationDegrees) -> CLLocationDegrees {
        return ((longitude + 180.0).truncatingRemainder(dividingBy: 360.0)) - 180.0
    }
}
