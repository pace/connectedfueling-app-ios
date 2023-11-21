import Foundation

/// Protocol that defines an input validator
protocol InputValidator {
    /**
     * Validates an optional input string and is returning the result
     *
     * - parameter input: The optional input string to validate
     *
     * - Returns: The Result of the validation
     */
    static func validate(input: String?) -> Result<Void, ValidationError>
}
