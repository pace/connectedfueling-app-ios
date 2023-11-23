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
            Image(.accountIcon)
                .frame(width: 40, height: 40, alignment: .center)
            VStack(alignment: .leading, spacing: 3) {
                TextLabel(L10n.walletHeaderText, textColor: .genericGrey)
                    .font(.system(size: 14))
                TextLabel("patrick@pace.car") // TODO: - Localized String
                    .font(.system(size: 16, weight: .medium))
                Button(action: {
                    viewModel.didTapLogout()
                }, label: {
                    TextLabel(L10n.Menu.Items.logout, textColor: .primaryTint)
                        .font(.system(size: 16, weight: .medium))
                })
            }
            .padding(.leading, 10)
        }
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
        .padding(.all, 15)
    }
}

#Preview {
    WalletAccountView(viewModel: .init())
}
