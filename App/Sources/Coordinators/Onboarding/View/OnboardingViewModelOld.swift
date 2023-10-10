import JamitFoundation
import UIKit

struct OnboardingViewModelOld: ViewModelProtocol {
    typealias Action = () -> Void

    let image: UIImage?
    let title: String
    let description: String
    let applyLargeTitleInset: Bool
    var isLoading: Bool
    var action: ButtonViewModel
    var radios: [ButtonViewModel]
    var secondaryAction: ButtonViewModel?

    init(
        image: UIImage? = Self.default.image,
        title: String = Self.default.title,
        description: String = Self.default.description,
        applyLargeTitleInset: Bool = Self.default.applyLargeTitleInset,
        isLoading: Bool = Self.default.isLoading,
        action: ButtonViewModel = Self.default.action,
        secondaryAction: ButtonViewModel? = Self.default.secondaryAction,
        radios: [ButtonViewModel] = Self.default.radios
    ) {
        self.image = image
        self.title = title
        self.description = description
        self.applyLargeTitleInset = applyLargeTitleInset
        self.isLoading = isLoading
        self.action = action
        self.secondaryAction = secondaryAction
        self.radios = radios
    }
}

extension OnboardingViewModelOld {
    static let `default`: Self = .init(
        image: nil,
        title: "",
        description: "",
        applyLargeTitleInset: true,
        isLoading: false,
        action: .default,
        secondaryAction: nil,
        radios: []
    )
}
