import SwiftUI

struct TwoFactorAuthenticationView: View {
    @StateObject private var viewModel: TwoFactorAuthenticationViewModel = .init()

    var body: some View {
        listView
            .navigationTitle(L10n.walletTwoFactorAuthenticationTitle)
            .sheet(item: $viewModel.inputViewModel) { inputViewModel in
                AppNavigationView {
                    OnboardingTextInputView(viewModel: inputViewModel)
                        .addNavigationBar(style: .standard(title: nil))
                }
            }
            .alert(item: $viewModel.alert) { alert in
                alert
            }
    }

    @ViewBuilder
    private var listView: some View {
        List {
            PINListItemView(viewModel: viewModel)
            if viewModel.isBiometricAuthenticationSupported {
                BiometryListItemView(viewModel: viewModel)
            }
        }
        .listStyle(.plain)
    }
}

private extension TwoFactorAuthenticationView {
    struct PINListItemView: View {
        @ObservedObject private var viewModel: TwoFactorAuthenticationViewModel

        init(viewModel: TwoFactorAuthenticationViewModel) {
            self.viewModel = viewModel
        }

        var body: some View {
            HStack(spacing: 0) {
                ListItemIconView(.walletTwoFactorAuthenticationPinIcon)
                    .padding(.trailing, .paddingXS)
                Button {
                    viewModel.presentPINSetup()
                } label: {
                    TextLabel(L10n.walletTwoFactorAuthenticationPinTitle)
                        .font(.system(size: 16, weight: .bold))
                }
                Spacer()
                DisclosureIndicator()
            }
        }
    }

    struct BiometryListItemView: View {
        @ObservedObject private var viewModel: TwoFactorAuthenticationViewModel

        init(viewModel: TwoFactorAuthenticationViewModel) {
            self.viewModel = viewModel
        }

        var body: some View {
            HStack(spacing: 0) {
                ListItemIconView(.walletTwoFactorAuthenticatonBiometryIcon)
                    .padding(.trailing, .paddingXS)
                TextLabel(L10n.walletTwoFactorAuthenticationBiometryTitle)
                    .font(.system(size: 16, weight: .bold))
                Spacer()
                Switch(isOn: viewModel.isBiometricAuthenticationEnabled,
                       onTap: viewModel.didTapBiometricAuthenticationToggle)
            }
        }
    }
}

#Preview {
    AppNavigationView {
        TwoFactorAuthenticationView()
            .addNavigationBar(style: .standard(title: L10n.walletTwoFactorAuthenticationTitle))
    }
}

#Preview {
    VStack {
        TwoFactorAuthenticationView.PINListItemView(viewModel: .init())
        TwoFactorAuthenticationView.BiometryListItemView(viewModel: .init())
    }
}
