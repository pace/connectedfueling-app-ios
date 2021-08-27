import Foundation

public struct Location {
    public let longitude: Double
    public let latitude: Double

    public init(longitude: Double, latitude: Double) {
        self.longitude = longitude
        self.latitude = latitude
    }

    func distance(to location: Location) -> Double {
        func haversin(_ angle: Double) -> Double {
            return (1 - cos(angle)) / 2
        }

        func ahaversin(_ angle: Double) -> Double {
            return 2 * asin(sqrt(angle))
        }

        let surfaceRadius = 6367444.7
        let lhsLongitudeInRadians = longitude / 360 * 2 * .pi
        let lhsLatitudeInRadians = latitude / 360 * 2 * .pi
        let rhsLongitudeInRadians = location.longitude / 360 * 2 * .pi
        let rhsLatitudeInRadians = location.latitude / 360 * 2 * .pi
        let haversinLatitude = haversin(rhsLatitudeInRadians - lhsLatitudeInRadians)
        let haversinLongitude = haversin(rhsLongitudeInRadians - lhsLongitudeInRadians)
        return surfaceRadius * ahaversin(haversinLatitude + cos(lhsLatitudeInRadians) * cos(rhsLatitudeInRadians) * haversinLongitude)
    }
}
