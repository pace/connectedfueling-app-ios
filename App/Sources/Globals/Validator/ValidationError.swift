import Foundation

enum ValidationError: Error {
    case empty
    case repetition
    case consecutiveOrder
    case invalidLength

    var localizedDescription: String? {
        switch self {
        case .empty:
            return nil

        case .invalidLength:
            return L10n.Onboarding.Pin.Error.invalidLength

        case .consecutiveOrder:
            return L10n.Onboarding.Pin.Error.series

        case .repetition:
            return L10n.Onboarding.Pin.Error.tooFewDigits
        }
    }
}
