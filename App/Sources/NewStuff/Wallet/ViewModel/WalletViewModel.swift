import PACECloudSDK
import SwiftUI

class WalletViewModel: ObservableObject {
    @Published private(set) var listItems: [WalletListItemViewModel] = []
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
                UserDefaults.standard.set(false, forKey: Constants.UserDefaults.isOnboardingCompleted)
            }
        }
    }
}

private extension WalletViewModel {
    var paymentMethodsListItem: WalletListItemViewModel {
        .init(icon: .walletTabItem,
              title: L10n.paymentMethodsTitle,
              navigationType: .detail(destination: AnyView(
                PaymentMethodsView()
              )))
    }

    var transactionsListItem: WalletListItemViewModel {
        .init(icon: .transactions,
              title: L10n.transactionsTitle,
              navigationType: .appPresentation(urlString: PACECloudSDK.URL.transactions.absoluteString))
    }

    var fuelTypeSelectionListItem: WalletListItemViewModel {
        .init(icon: .fuelTypeSelection,
              title: L10n.fuelSelectionTitle,
              navigationType: .detail(destination: AnyView(
                FuelTypeSelectionView()
              )))
    }
}
