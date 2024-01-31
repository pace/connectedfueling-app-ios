import PACECloudSDK
import SwiftUI

class WalletViewModel: ObservableObject {
    @Published private(set) var listItems: [ListItem] = []
    @Published var alert: Alert?

    var email: String? {
        userManager.email
    }

    private let userManager: UserManager
    private let paymentManager: PaymentManager

    init(userManager: UserManager = .init(),
         paymentManager: PaymentManager = .init(),
         configuration: ConfigurationManager.Configuration = ConfigurationManager.configuration) {
        self.userManager = userManager
        self.paymentManager = paymentManager

        determineListItems(with: configuration)
    }

    private func determineListItems(with configuration: ConfigurationManager.Configuration) {
        var listItems: [ListItem] = [
            paymentMethodsListItem,
            transactionsListItem
        ]

        if !configuration.hidePrices {
            listItems.append(fuelTypeSelectionListItem)
        }

        if UserDefaults.is2FANeededForPayments {
            listItems.append(twoFactorAuthenticationListItem)
        }

        listItems.append(accountDeletionListItem)
        self.listItems = listItems
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
              action: .detail(destination: AnyView(
                TransactionListView(viewModel: .init())
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
