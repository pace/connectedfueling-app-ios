import JamitFoundation
import UIKit

struct ButtonViewModel: ViewModelProtocol {
    typealias Action = () -> Void

    let icon: UIImage?
    var title: String
    var isEnabled: Bool
    var isSelected: Bool
    let action: Action

    init(
        icon: UIImage? = Self.default.icon,
        title: String = Self.default.title,
        isEnabled: Bool = Self.default.isEnabled,
        isSelected: Bool = Self.default.isSelected,
        action: @escaping Action = Self.default.action
    ) {
        self.icon = icon
        self.title = title
        self.isEnabled = isEnabled
        self.isSelected = isSelected
        self.action = action
    }
}

extension ButtonViewModel {
    // swiftlint:disable:next trailing_closure
    static let `default`: Self = .init(
        icon: nil,
        title: "",
        isEnabled: true,
        isSelected: false,
        action: { }
    )
}
