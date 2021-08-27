import Domain
import JamitFoundation
import JLCoordinator
import PACECloudSDK
import UIKit

protocol MenuCoordinatorDelegate: AnyObject {
    func didTriggerAction(_ action: MenuCoordinator.Action, in coordinator: MenuCoordinator)
}

final class MenuCoordinator: Coordinator {
    enum Action {
        case openImprint
        case openPrivacyPolicy
        case openFuelTypeSelection
        case openPaymentMethods
        case openPaymentHistory
        case logout
    }

    private let userInteractor: UserInteractor
    private lazy var viewController: MenuViewController = .instantiate()
    private var action: Action?

    weak var delegate: MenuCoordinatorDelegate?

    var isPresenting: Bool { viewController.isBeingPresented || viewController.isBeingDismissed }

    init(userInteractor: UserInteractor, presenter: Presenter) {
        self.userInteractor = userInteractor

        super.init(presenter: presenter)
    }

    override func start() {
        viewController.model = .init(
            headerTitle: L10n.Menu.Title.placeholder,
            headerImage: nil,
            sections: [
                makeSettingsSection(),
                makeDocumentSection(),
                makeProfileSection()
            ]
        )

        presenter.present(viewController, animated: true)
        updateHeader()
    }

    override func presenter(_ presenter: Presenter, didDismiss viewController: UIViewController) {
        guard let action = action else { return }

        self.action = nil

        delegate?.didTriggerAction(action, in: self)
    }

    private func updateHeader() {
        viewController.model.isLoading = true
        userInteractor.fetchUserInfo { [weak self] result in
            self?.viewController.model.isLoading = false

            guard case let .success(userInfo) = result else { return }

            let isEmailAvailable = userInfo.email != nil
            self?.viewController.model.headerTitle = userInfo.email ?? L10n.Menu.Title.placeholder
            self?.viewController.model.headerImage = isEmailAvailable ? Asset.Images.MenuItems.profile.image : nil
        }
    }

    private func makeDocumentSection() -> MenuViewModel.Section {
        return .init(
            items: [
                ActionViewModel(
                    content: MenuItemViewModel(
                        title: L10n.Menu.Items.imprint,
                        icon: Asset.Images.MenuItems.imprint.image
                    )
                ) { [weak self] in
                    self?.didTriggerAction(.openImprint)
                },
                ActionViewModel(
                    content: MenuItemViewModel(
                        title: L10n.Menu.Items.privacy,
                        icon: Asset.Images.MenuItems.privacyPolicy.image
                    )
                ) { [weak self] in
                    self?.didTriggerAction(.openPrivacyPolicy)
                }
            ]
        )
    }

    private func makeSettingsSection() -> MenuViewModel.Section {
        return .init(
            items: [
                ActionViewModel(
                    content: MenuItemViewModel(
                        title: L10n.Menu.Items.fuelType,
                        icon: Asset.Images.MenuItems.fuelType.image
                    )
                ) { [weak self] in
                    self?.didTriggerAction(.openFuelTypeSelection)
                },
                ActionViewModel(
                    content: MenuItemViewModel(
                        title: L10n.Menu.Items.paymentMethods,
                        icon: Asset.Images.MenuItems.paymentMethods.image
                    )
                ) { [weak self] in
                    self?.didTriggerAction(.openPaymentMethods)
                },
                ActionViewModel(
                    content: MenuItemViewModel(
                        title: L10n.Menu.Items.paymentHistory,
                        icon: Asset.Images.MenuItems.paymentHistory.image
                    )
                ) { [weak self] in
                    self?.didTriggerAction(.openPaymentHistory)
                }
            ]
        )
    }

    private func makeProfileSection() -> MenuViewModel.Section {
        return .init(
            items: [
                ActionViewModel(
                    content: MenuItemViewModel(
                        title: L10n.Menu.Items.logout,
                        icon: Asset.Images.MenuItems.logout.image
                    )
                ) { [weak self] in
                    self?.didTriggerAction(.logout)
                }
            ]
        )
    }
}

// MARK: - Actions
extension MenuCoordinator {
    private func didTriggerAction(_ action: Action) {
        self.action = action

        presenter.dismiss(viewController, animated: true)
    }
}
