import CoreLocation
import Foundation

struct GasStation: Hashable, Comparable {
    let id: String
    let name: String
    let addressLines: [String]
    let distanceInKilometers: Double?
    let location: CLLocation?
    let paymentMethods: [String]
    let isConnectedFuelingEnabled: Bool
    let fuelType: FuelType?
    let fuelPrice: FuelPrice?

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: GasStation, rhs: GasStation) -> Bool {
        lhs.id == rhs.id
    }

    static func < (lhs: GasStation, rhs: GasStation) -> Bool {
        guard let lhsDistance = lhs.distanceInKilometers,
              let rhsDistance = rhs.distanceInKilometers else { return false }

        return lhsDistance < rhsDistance
    }
}
