import Domain
import JamitFoundation
import UIKit

struct DashboardItemViewModel: ViewModelProtocol {
    let icon: UIImage?
    let title: String
    let description: String
    let price: Double?
    let fuelType: FuelType?
    let currency: String?
    let distance: Double
    let isPrimaryAction: Bool
    let action: ButtonViewModel

    init(
        icon: UIImage? = Self.default.icon,
        title: String = Self.default.title,
        description: String = Self.default.description,
        price: Double? = Self.default.price,
        fuelType: FuelType? = Self.default.fuelType,
        currency: String? = Self.default.currency,
        distance: Double = Self.default.distance,
        isPrimaryAction: Bool = Self.default.isPrimaryAction,
        action: ButtonViewModel = Self.default.action
    ) {
        self.icon = icon
        self.title = title
        self.description = description
        self.price = price
        self.currency = currency
        self.distance = distance
        self.isPrimaryAction = isPrimaryAction
        self.action = action
        self.fuelType = fuelType
    }
}

extension DashboardItemViewModel {
    static let `default`: Self = .init(
        icon: nil,
        title: "",
        description: "",
        price: nil,
        fuelType: nil,
        currency: nil,
        distance: 0,
        isPrimaryAction: true,
        action: .default
    )
}
