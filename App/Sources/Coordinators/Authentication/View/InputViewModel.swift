import JamitFoundation
import UIKit

struct InputViewModel: ViewModelProtocol {
    typealias ValidationCallback = (String?) -> Void
    typealias SubmitCallback = (String) -> Void

    let title: String
    let description: String
    let submitTitle: String
    var error: String?
    var isConfirmButtonEnabled: Bool = false
    let onValidate: ValidationCallback
    let onSubmit: SubmitCallback

    init(
        title: String = Self.default.title,
        description: String = Self.default.description,
        submitTitle: String = Self.default.submitTitle,
        error: String? = Self.default.error,
        isConfirmButtonEnabled: Bool = Self.default.isConfirmButtonEnabled,
        onValidate: @escaping ValidationCallback = Self.default.onValidate,
        onSubmit: @escaping SubmitCallback = Self.default.onSubmit
    ) {
        self.title = title
        self.description = description
        self.submitTitle = submitTitle
        self.error = error
        self.isConfirmButtonEnabled = isConfirmButtonEnabled
        self.onValidate = onValidate
        self.onSubmit = onSubmit
    }
}

extension InputViewModel {
    static let `default`: Self = .init(
        title: "",
        description: "",
        submitTitle: "",
        error: nil,
        isConfirmButtonEnabled: false,
        onValidate: { _ in },
        onSubmit: { _ in }
    )
}
