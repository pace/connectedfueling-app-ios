import Foundation

enum FuelType: String, Codable {
    case cheapestDiesel
    case cheapestPetrol

    case diesel
    case dieselB7
    case dieselGtl
    case dieselB0
    case dieselPremium

    case ron95e5
    case ron95e10
    case ron98e5
    case ron100
    case premiumPetrol

    var localizedTitle: String {
        switch self {
        case .cheapestPetrol:
            return L10n.fuelGroupPetrol

        case .cheapestDiesel:
            return L10n.fuelGroupDiesel

        case .diesel, .dieselB7:
            return L10n.FuelType.diesel

        case .dieselGtl, .dieselB0, .dieselPremium:
            return "Diesel Premium" // TODO: - Localized String

        case .ron95e5:
            return L10n.FuelType.super

        case .ron95e10:
            return L10n.FuelType.superE10

        case .ron98e5:
            return L10n.FuelType.superPlus

        case .ron100, .premiumPetrol:
            return "Super Premium" // TODO: - Localized String
        }
    }

    var keys: [String] {
        let fuelTypes: [FuelType] = switch self {
        case .cheapestDiesel:
            [
                .diesel,
                .dieselB7,
                .dieselB0,
                .dieselGtl,
                .dieselPremium
            ]

        case .cheapestPetrol:
            [
                .ron95e5,
                .ron95e10,
                .ron98e5,
                .ron100,
                .premiumPetrol
            ]

        case .diesel, .dieselB7:
            [
                .diesel,
                .dieselB7
            ]

        case .dieselGtl, .dieselB0, .dieselPremium:
            [
                .dieselGtl,
                .dieselB0,
                .dieselPremium
            ]

        case .ron95e5, .ron95e10, .ron98e5:
            [self]

        case .ron100, .premiumPetrol:
            [
                .ron100,
                .premiumPetrol
            ]
        }

        return fuelTypes.map { $0.rawValue }
    }

    var isPetrol: Bool {
        [
            FuelType.cheapestPetrol,
            .ron95e5,
            .ron95e10,
            .ron98e5,
            .ron100,
            .premiumPetrol
        ].contains(self)
    }

    var isDiesel: Bool {
        [
            FuelType.cheapestDiesel,
            .diesel,
            .dieselB7,
            .dieselB0,
            .dieselGtl,
            .dieselPremium
        ].contains(self)
    }

    static let selectableFilters: [FuelType] = [.cheapestDiesel, .cheapestPetrol]
}
