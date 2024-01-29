import Combine
import CoreLocation
import PACECloudSDK

class GasStation: Hashable, Comparable {
    let id: String
    let name: String
    let addressLines: [String]
    let distanceInKilometers: Double?
    let location: CLLocation
    let paymentMethods: [String]
    let isConnectedFuelingEnabled: Bool
    let prices: [FuelPrice]
    let lastUpdated: Date?

    /// opening / operating hours
    let openingHours: [OpeningHours]

    var poiOpeningHours: [PCPOICommonOpeningHours.Rules] {
        openingHours.map { $0.poiConverted() }
    }

    var closesIn: Int {
        poiOpeningHours.minuteTillClose()
    }

    var isClosed: Bool {
        !openingHours.isEmpty && closesIn == -Int.max
    }

    var isNearby: Bool {
        distanceInKilometers ?? .infinity < Constants.Distance.formattingThresholdForMetersPrecision - Constants.Distance.roundingThreshold
    }

    @Published var currentPrice: FuelPrice?

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

        POIManager().selectedFuelTypePublisher
            .map { [weak self] selectedFuelType in
                guard let self = self else { return nil }
                return self.lowestPrice(for: selectedFuelType.keys)
            }
            .eraseToAnyPublisher()
            .assign(to: &$currentPrice)
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
