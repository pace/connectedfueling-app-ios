import Foundation

public struct GasStation {
    public let identifier: String?
    public let name: String
    public let addressLines: [String]
    public let distanceInKilometers: Float?
    public let location: Location?
    public let paymentMethods: [String]
    public let isFuelingAvailable: Bool
    public let isFuelingEnabled: Bool
    public let fuelPrice: FuelPrice?
    public let currency: String?

    public init(
        identifier: String?,
        name: String,
        addressLines: [String],
        distanceInKilometers: Float?,
        location: Location?,
        paymentMethods: [String],
        isFuelingAvailable: Bool,
        isFuelingEnabled: Bool,
        fuelPrice: FuelPrice?,
        currency: String?
    ) {
        self.identifier = identifier
        self.name = name
        self.addressLines = addressLines
        self.distanceInKilometers = distanceInKilometers
        self.location = location
        self.paymentMethods = paymentMethods
        self.isFuelingAvailable = isFuelingAvailable
        self.isFuelingEnabled = isFuelingEnabled
        self.fuelPrice = fuelPrice
        self.currency = currency
    }
}
