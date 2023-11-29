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
            return L10n.onboardingPinErrorInvalidLength

        case .consecutiveOrder:
            return L10n.onboardingPinErrorSeries

        case .repetition:
            return L10n.onboardingPinErrorTooFewDigits
        }
    }
}
