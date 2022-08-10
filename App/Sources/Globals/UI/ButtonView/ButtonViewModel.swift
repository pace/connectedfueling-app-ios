import JamitFoundation
import UIKit

struct ButtonViewModel: ViewModelProtocol {
    typealias Action = () -> Void

    let icon: UIImage?
    let selectedIcon: UIImage?
    var title: String
    var isEnabled: Bool
    var isSelected: Bool
    let action: Action

    init(
        icon: UIImage? = Self.default.icon,
        selectedIcon: UIImage? = Self.default.selectedIcon,
        title: String = Self.default.title,
        isEnabled: Bool = Self.default.isEnabled,
        isSelected: Bool = Self.default.isSelected,
        action: @escaping Action = Self.default.action
    ) {
        self.icon = icon
        self.selectedIcon = selectedIcon
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
        selectedIcon: nil,
        title: "",
        isEnabled: true,
        isSelected: false,
        action: { }
    )
}
