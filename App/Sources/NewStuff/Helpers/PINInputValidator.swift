import Foundation

enum PINInputValidator {
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

    static func validate(pin: String?) -> Result<Void, ValidationError> {
        guard let pin = pin, !pin.isEmpty else { return .failure(.empty) }

        guard pin.count == Constants.pinDigitsCount else { return .failure(.invalidLength) }
        guard Set(Array(pin)).count >= 3 else { return .failure(.repetition) }
        let intArray = pin.compactMap { Int("\($0)") }

        guard
            intArray.map({ $0 - 1 }).dropFirst() != intArray.dropLast(),
            intArray.reversed().map({ $0 - 1 }).dropFirst() != intArray.reversed().dropLast()
        else {
            return .failure(.consecutiveOrder)
        }

        return .success(())
    }
}
