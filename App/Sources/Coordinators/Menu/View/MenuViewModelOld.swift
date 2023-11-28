import JamitFoundation
import UIKit

struct MenuViewModelOld: ViewModelProtocol {
    struct Section {
        let items: [ActionViewModel<MenuItemViewModel>]
    }

    var headerTitle: String
    var headerImage: UIImage?
    var isLoading: Bool
    let sections: [Section]

    init(
        headerTitle: String = Self.default.headerTitle,
        headerImage: UIImage? = Self.default.headerImage,
        isLoading: Bool = Self.default.isLoading,
        sections: [Section] = Self.default.sections
    ) {
        self.headerTitle = headerTitle
        self.headerImage = headerImage
        self.isLoading = isLoading
        self.sections = sections
    }
}

extension MenuViewModelOld {
    static let `default`: Self = .init(
        headerTitle: "",
        headerImage: nil,
        isLoading: false,
        sections: []
    )
}
