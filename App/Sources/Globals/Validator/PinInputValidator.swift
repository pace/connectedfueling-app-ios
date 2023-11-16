import Foundation

enum PinInputValidator: InputValidator {
    /**
     * Validates an optional input string and is returning the result.
     *
     * Validation rules are:
     * - is input nil or empty
     * - is input lenght equal 4
     * - is number of different digits greater or equal than 3
     * - is input a consecutive order
     *
     * - Parameter input: The string to validate
     * - Returns: The result of the validation
     */
    static func validate(input: String?) -> Result<Void, ValidationError> {
        guard let input = input, !input.isEmpty else { return .failure(.empty) }

        guard input.count == 4 else { return .failure(.invalidLength) }
        guard Set(Array(input)).count >= 3 else { return .failure(.repetition) }
        let intArray = input.compactMap { Int("\($0)") }

        guard
            intArray.map({ $0 - 1 }).dropFirst() != intArray.dropLast(),
            intArray.reversed().map({ $0 - 1 }).dropFirst() != intArray.reversed().dropLast()
        else {
            return .failure(.consecutiveOrder)
        }

        return .success(())
    }
}
