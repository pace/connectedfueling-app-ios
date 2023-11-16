import SwiftUI

struct WalletNavigationView: View {
    var body: some View {
        AppNavigationView {
            WalletView()
                .addNavigationBar(showsLogo: false, navigationTitle: L10n.walletTabLabel)
        }

    }
}

#Preview {
    WalletNavigationView()
}
