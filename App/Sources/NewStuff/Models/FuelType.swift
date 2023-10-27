import Foundation

enum FuelType: String, CaseIterable, Codable {
    case diesel
    case ron95e5
    case ron95e10
    case ron98e5

    var localizedTitle: String {
        switch self {
        case .diesel:
            return L10n.FuelType.diesel

        case .ron95e5:
            return L10n.FuelType.super

        case .ron95e10:
            return L10n.FuelType.superE10

        case .ron98e5:
            return L10n.FuelType.superPlus
        }
    }
}
