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
//                makeDocumentSection(),
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
            self?.viewController.model.headerImage = nil
        }
    }

    private func makeDocumentSection() -> MenuViewModelOld.Section {
        return .init(
            items: [
                ActionViewModel(
                    content: MenuItemViewModel(
                        title: L10n.Menu.Items.imprint,
                        icon: nil
                    )
                ) { [weak self] in
                    self?.didTriggerAction(.openImprint)
                },
                ActionViewModel(
                    content: MenuItemViewModel(
                        title: L10n.Menu.Items.privacy,
                        icon: nil
                    )
                ) { [weak self] in
                    self?.didTriggerAction(.openPrivacyPolicy)
                }
            ]
        )
    }

    private func makeSettingsSection() -> MenuViewModelOld.Section {
        return .init(
            items: [
                ActionViewModel(
                    content: MenuItemViewModel(
                        title: L10n.Menu.Items.fuelType,
                        icon: nil
                    )
                ) { [weak self] in
                    self?.didTriggerAction(.openFuelTypeSelection)
                },
                ActionViewModel(
                    content: MenuItemViewModel(
                        title: L10n.Menu.Items.paymentMethods,
                        icon: nil
                    )
                ) { [weak self] in
                    self?.didTriggerAction(.openPaymentMethods)
                },
                ActionViewModel(
                    content: MenuItemViewModel(
                        title: L10n.Menu.Items.paymentHistory,
                        icon: nil
                    )
                ) { [weak self] in
                    self?.didTriggerAction(.openPaymentHistory)
                }
            ]
        )
    }

    private func makeProfileSection() -> MenuViewModelOld.Section {
        return .init(
            items: [
                ActionViewModel(
                    content: MenuItemViewModel(
                        title: L10n.Menu.Items.logout,
                        icon: nil
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
