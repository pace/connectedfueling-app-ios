import CoreLocation
import PACECloudSDK

class GasStation: ObservableObject, Hashable, Comparable {
    let id: String
    let name: String
    let addressLines: [String]
    @Published var distanceInKilometers: Double?
    let location: CLLocation
    let paymentMethods: [String]
    let isConnectedFuelingEnabled: Bool
    @Published var prices: [FuelPrice]
    @Published var lastUpdated: Date?

    /// opening / operating hours
    let openingHours: [OpeningHours]

    var poiOpeningHours: [PCPOICommonOpeningHours.Rules] {
        openingHours.map { $0.poiConverted() }
    }

    init(id: String,
         name: String,
         addressLines: [String],
         distanceInKilometers: Double?,
         location: CLLocation,
         paymentMethods: [String],
         isConnectedFuelingEnabled: Bool,
         prices: [FuelPrice],
         lastUpdated: Date?,
         openingHours: [OpeningHours]) {
        self.id = id
        self.name = name
        self.addressLines = addressLines
        self.distanceInKilometers = distanceInKilometers
        self.location = location
        self.paymentMethods = paymentMethods
        self.isConnectedFuelingEnabled = isConnectedFuelingEnabled
        self.prices = prices
        self.lastUpdated = lastUpdated
        self.openingHours = openingHours
    }

    func lowestPrice(for fuelTypeKeys: [String]) -> FuelPrice? {
        prices
            .filter { fuelTypeKeys.contains($0.fuelType.rawValue) }
            .min(by: { $0.value < $1.value })
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
