import Foundation

enum EmptyInputValidator: InputValidator {
    static func validate(input: String?) -> Result<Void, ValidationError> {
        guard input?.isEmpty == false else { return .failure(.empty) }

        return .success(())
    }
}
