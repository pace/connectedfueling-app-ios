import CoreLocation
import PACECloudSDK

struct FuelPriceInfo {
    let fuelType: FuelType
    let fuelPrice: FuelPrice
}

class GasStation: ObservableObject, Hashable, Comparable {
    let id: String
    let name: String
    let addressLines: [String]
    @Published var distanceInKilometers: Double?
    let location: CLLocation?
    let paymentMethods: [String]
    let isConnectedFuelingEnabled: Bool
    let fuelType: FuelType? // TODO: use selected fueltype (&fuelPrice) in `prices`
    let fuelPrice: FuelPrice?
    @Published var prices: [FuelPriceInfo]
    @Published var lastUpdated: Date?

    /// opening / operating hours
    let openingHours: [OpeningHours]

    var poiOpeningHours: [PCPOICommonOpeningHours.Rules] {
        openingHours.map { $0.poiConverted() }
    }

    init(id: String, name: String, addressLines: [String], distanceInKilometers: Double?, location: CLLocation?, paymentMethods: [String], isConnectedFuelingEnabled: Bool, fuelType: FuelType?, fuelPrice: FuelPrice?, prices: [FuelPriceInfo], lastUpdated: Date?, openingHours: [OpeningHours]) {
        self.id = id
        self.name = name
        self.addressLines = addressLines
        self.distanceInKilometers = distanceInKilometers
        self.location = location
        self.paymentMethods = paymentMethods
        self.isConnectedFuelingEnabled = isConnectedFuelingEnabled
        self.fuelType = fuelType
        self.fuelPrice = fuelPrice
        self.prices = prices
        self.lastUpdated = lastUpdated
        self.openingHours = openingHours
    }

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
