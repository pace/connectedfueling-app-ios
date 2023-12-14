import SwiftUI

struct WalletView: View {
    @StateObject private var viewModel: WalletViewModel = .init()

    var body: some View {
        VStack(spacing: 0) {
            WalletAccountView(viewModel: viewModel)
                .padding(.top, 10)
                .padding(.horizontal, 20)
            Image(.deutschlandCardTeaser)
                .resizable()
                .scaledToFit()
            ListView(listItems: viewModel.listItems)
                .padding(.top, 10)
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
