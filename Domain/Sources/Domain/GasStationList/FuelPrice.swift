import Foundation

public struct FuelPrice {
    public let value: Double
    public let currency: String?

    public init(value: Double, currency: String?) {
        self.value = value
        self.currency = currency
    }
}
