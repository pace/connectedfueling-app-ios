import SwiftUI

struct WalletAccountView: View {
    @ObservedObject private var viewModel: WalletViewModel

    init(viewModel: WalletViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        content
            .background(BackgroundContainer())
            .alert(item: $viewModel.alert) { alert in
                alert
            }
    }

    @ViewBuilder
    private var content: some View {
        HStack(spacing: 0) {
            Image(.walletAccountIcon)
                .resizable()
                .frame(width: 40, height: 40)
            VStack(alignment: .leading, spacing: 2) {
                TextLabel(L10n.walletHeaderText, textColor: .genericGrey)
                    .font(.system(size: 14))
                if let email = viewModel.email {
                    Text(verbatim: email)
                        .foregroundStyle(Color.genericBlack)
                        .font(.system(size: 16, weight: .bold))
                        .multilineTextAlignment(.center)
                }
                Button(action: {
                    viewModel.didTapLogout()
                }, label: {
                    TextLabel(L10n.Menu.Items.logout, textColor: .primaryTint)
                        .font(.system(size: 16, weight: .bold))
                })
            }
            .padding(.leading, 10)
        }
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
        .padding(.all, .paddingS)
    }
}

#Preview {
    WalletAccountView(viewModel: .init())
}