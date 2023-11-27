import PACECloudSDK
import SwiftUI

class WalletViewModel: ObservableObject {
    @Published private(set) var listItems: [ListItem] = []
    @Published var alert: Alert?

    private let userManager: UserManager

    init(userManager: UserManager = .init()) {
        self.userManager = userManager

        listItems = [
            paymentMethodsListItem,
            transactionsListItem,
            fuelTypeSelectionListItem
        ]
    }

    func didTapLogout() {
        alert = AppAlert.logout(logoutAction: logout)
    }

    private func logout() {
        Task { @MainActor [weak self] in
            guard let result = await self?.userManager.logout() else { return }

            switch result {
            case .failure(let error):
                NSLog("[WalletViewModel] Failed logging out with error \(error)")
                self?.alert = AppAlert.genericError

            default:
                NSLog("[WalletViewModel] Successfully logged out user")
                self?.reset()
            }
        }
    }

    private func reset() {
        UserDefaults.standard.set(false, forKey: Constants.UserDefaults.isOnboardingCompleted)
        UserDefaults.standard.set(false, forKey: Constants.UserDefaults.isAnalyticsAllowed)
    }
}

private extension WalletViewModel {
    var paymentMethodsListItem: ListItem {
        .init(icon: .walletTabIcon,
              title: L10n.paymentMethodsTitle,
              action: .detail(destination: AnyView(
                PaymentMethodsView()
              )))
    }

    var transactionsListItem: ListItem {
        .init(icon: .transactions,
              title: L10n.transactionsTitle,
              action: .presentedContent(AnyView(
                AppView(urlString: PACECloudSDK.URL.transactions.absoluteString)
              )))
    }

    var fuelTypeSelectionListItem: ListItem {
        .init(icon: .fuelTypeSelection,
              title: L10n.fuelSelectionTitle,
              action: .detail(destination: AnyView(
                FuelTypeSelectionView()
              )))
    }
}
