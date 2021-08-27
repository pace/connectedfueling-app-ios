import JamitFoundation
import UIKit

struct DocumentViewModel: ViewModelProtocol {
    let content: String?
    let closeAction: (() -> Void)?

    init(
        content: String? = Self.default.content,
        closeAction: (() -> Void)? = Self.default.closeAction
    ) {
        self.content = content
        self.closeAction = closeAction
    }
}

extension DocumentViewModel {
    static let `default`: Self = .init(
        content: nil,
        closeAction: nil
    )
}
