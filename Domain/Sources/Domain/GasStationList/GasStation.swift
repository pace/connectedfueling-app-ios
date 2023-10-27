import Foundation

public struct GasStation {
    public let identifier: String?
    public let name: String
    public let addressLines: [String]
    public let distanceInKilometers: Float?
    public let location: Domain.Location?
    public let paymentMethods: [String]
    public let isFuelingAvailable: Bool
    public let isFuelingEnabled: Bool
    public let fuelType: Domain.FuelType?
    public let fuelPrice: Domain.FuelPrice?
    public let currency: String?

    public init(
        identifier: String?,
        name: String,
        addressLines: [String],
        distanceInKilometers: Float?,
        location: Domain.Location?,
        paymentMethods: [String],
        isFuelingAvailable: Bool,
        isFuelingEnabled: Bool,
        fuelType: Domain.FuelType?,
        fuelPrice: Domain.FuelPrice?,
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
        self.fuelType = fuelType
        self.fuelPrice = fuelPrice
        self.currency = currency
    }
}
