import JamitFoundation
import UIKit

struct MenuItemViewModel: ViewModelProtocol {
    let title: String
    let icon: UIImage?

    init(
        title: String = Self.default.title,
        icon: UIImage? = Self.default.icon
    ) {
        self.title = title
        self.icon = icon
    }
}

extension MenuItemViewModel {
    static let `default`: Self = .init(
        title: "",
        icon: nil
    )
}
