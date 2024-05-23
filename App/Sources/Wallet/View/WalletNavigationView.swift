import SwiftUI

struct WalletNavigationView: View {
    var body: some View {
        AppNavigationView {
            WalletView()
                .addNavigationBar(style: .standard(title: L10n.walletTabLabel))
        }

    }
}

#Preview {
    WalletNavigationView()
}
