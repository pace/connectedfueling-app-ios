import SwiftUI

struct WalletView: View {
    @StateObject private var viewModel: WalletViewModel = .init()

    var body: some View {
        VStack(spacing: 0) {
            WalletAccountView(viewModel: viewModel)
                .padding(.top, .paddingXS)
                .padding(.horizontal, .paddingM)
            ListView(listItems: viewModel.listItems)
                .padding(.top, .paddingL)
            Spacer()
        }
    }
}

#Preview {
    AppNavigationView {
        WalletView()
            .addNavigationBar(style: .standard(title: L10n.walletTabLabel))
    }
}
