import JamitFoundation
import UIKit

struct LoadingViewModel: ViewModelProtocol {
    let image: UIImage?
    let title: String
    let description: String

    init(
        image: UIImage? = Self.default.image,
        title: String = Self.default.title,
        description: String = Self.default.description
    ) {
        self.image = image
        self.title = title
        self.description = description
    }
}

extension LoadingViewModel {
    static let `default`: Self = .init(
        image: nil,
        title: "",
        description: ""
    )
}
