import JamitFoundation
import UIKit

struct OnboardingViewModel: ViewModelProtocol {
    typealias Action = () -> Void

    let image: UIImage?
    let title: String
    let description: String
    let applyLargeTitleInset: Bool
    let applySecondaryActionInset: Bool
    var isLoading: Bool
    var actions: [ButtonViewModel]
    var secondaryAction: ButtonViewModel?

    init(
        image: UIImage? = Self.default.image,
        title: String = Self.default.title,
        description: String = Self.default.description,
        applyLargeTitleInset: Bool = Self.default.applyLargeTitleInset,
        applySecondaryActionInset: Bool = Self.default.applySecondaryActionInset,
        isLoading: Bool = Self.default.isLoading,
        actions: [ButtonViewModel] = Self.default.actions,
        secondaryAction: ButtonViewModel? = Self.default.secondaryAction
    ) {
        self.image = image
        self.title = title
        self.description = description
        self.applyLargeTitleInset = applyLargeTitleInset
        self.applySecondaryActionInset = applySecondaryActionInset
        self.isLoading = isLoading
        self.actions = actions
        self.secondaryAction = secondaryAction
    }
}

extension OnboardingViewModel {
    static let `default`: Self = .init(
        image: nil,
        title: "",
        description: "",
        applyLargeTitleInset: true,
        applySecondaryActionInset: true,
        isLoading: false,
        actions: [],
        secondaryAction: nil
    )
}
