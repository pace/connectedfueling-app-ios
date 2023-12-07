import PACECloudSDK
import SwiftUI

class WalletViewModel: ObservableObject {
    @Published private(set) var listItems: [ListItem] = []
    @Published var alert: Alert?

    var email: String? {
        userManager.email
    }

    private let userManager: UserManager

    init(userManager: UserManager = .init()) {
        self.userManager = userManager

        listItems = [
            paymentMethodsListItem,
            transactionsListItem,
            fuelTypeSelectionListItem,
            twoFactorAuthenticationListItem,
            accountDeletionListItem
        ]
    }

    private func logout() {
        Task { [weak self] in
            await self?.userManager.logout()
        }
    }

    func didTapLogout() {
        alert = AppAlert.logout(logoutAction: logout)
    }

    func checkAccountDeletion() {
        // If the account got deleted
        // the token refresh will fail and the session will be reset
        Task { [weak self] in
            await self?.userManager.refresh()
        }
    }
}

private extension WalletViewModel {
    var paymentMethodsListItem: ListItem {
        .init(icon: .walletTabIcon,
              title: L10n.walletPaymentMethodsTitle,
              action: .detail(destination: AnyView(
                PaymentMethodsView()
              )))
    }

    var transactionsListItem: ListItem {
        .init(icon: .walletTransactionsIcon,
              title: L10n.walletTransactionsTitle,
              action: .presentedContent(AnyView(
                AppView(urlString: PACECloudSDK.URL.transactions.absoluteString)
              )))
    }

    var fuelTypeSelectionListItem: ListItem {
        .init(icon: .walletFuelTypeSelectionIcon,
              title: L10n.walletFuelTypeSelectionTitle,
              action: .detail(destination: AnyView(
                FuelTypeSelectionView()
              )))
    }

    var twoFactorAuthenticationListItem: ListItem {
        .init(icon: .walletTwoFactorAuthenticationIcon,
              title: L10n.walletTwoFactorAuthenticationTitle,
              action: .detail(destination: AnyView(
                TwoFactorAuthenticationView()
              )))
    }

    var accountDeletionListItem: ListItem {
        .init(icon: .walletAccountDeletionIcon,
              title: L10n.walletAccountDeletionTitle,
              action: .presentedContent(AnyView(
                AppView(urlString: PACECloudSDK.URL.paceID.absoluteString, completion: checkAccountDeletion)
              )))
    }
}
