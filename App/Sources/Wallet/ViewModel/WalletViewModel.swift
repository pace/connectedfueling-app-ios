import PACECloudSDK
import SwiftUI

class WalletViewModel: ObservableObject {
    @Published private(set) var listItems: [ListItem] = []
    @Published var alert: Alert?

    var email: String? {
        userManager.email
    }

    private let userManager: UserManager

    init(userManager: UserManager = .init(), configuration: ConfigurationManager.Configuration = ConfigurationManager.configuration) {
        self.userManager = userManager

        listItems = [
            bonusItemList,
            paymentMethodsListItem,
            transactionsListItem
        ]

        if !configuration.hidePrices {
            listItems.append(fuelTypeSelectionListItem)
        }

        listItems += [
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
    var bonusItemList: ListItem {
        .init(icon: .walletBonusIcon,
              title: L10n.walletBonusTitle,
              action: .detail(destination: AnyView(
                BonusView()
              )))
    }

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
                    .navigationTitle(L10n.walletTransactionsTitle)
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
