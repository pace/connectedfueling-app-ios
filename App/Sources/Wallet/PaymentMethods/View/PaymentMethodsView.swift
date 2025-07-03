import SwiftUI

struct PaymentMethodsView: View {
    @StateObject private var viewModel: PaymentMethodsViewModel = .init()

    var body: some View {
        VStack {
            if viewModel.isLoading {
                loadingView
            } else if let error = viewModel.error {
                errorView(with: error)
            } else {
                paymentMethodsList
            }
        }
    }

    @ViewBuilder
    private var loadingView: some View {
        VStack(spacing: 0) {
            LoadingView(title: L10n.paymentMethodsLoadingTitle,
                        description: L10n.paymentMethodsLoadingDescription)
            Spacer()
        }
        .padding([.top, .horizontal], .paddingM)
    }

    @ViewBuilder
    private var paymentMethodsList: some View {
        VStack(spacing: 0) {
            PaymentMethodsListView(viewModel: viewModel)
            Spacer()

            if viewModel.isNativePaymentMethodOnboardingEnabled {
                ActionButton(title: L10n.paymentMethodsAddButton, style: .secondary) {
                    viewModel.showPaymentApp()
                }
                .padding(.horizontal, .paddingM)
            }
        }
        .padding(.bottom, 10)
        .sheet(item: $viewModel.paymentAppUrlString) { urlString in
            AppView(urlString: urlString) {
                viewModel.didClosePaymentApp()
            }
        }
    }

    @ViewBuilder
    func errorView(with error: AppError) -> some View {
        VStack(spacing: 0) {
            ErrorView(error)
            Spacer()
        }
        .padding([.top, .horizontal], .paddingM)
    }
}

#Preview {
    AppNavigationView {
        PaymentMethodsView()
            .addNavigationBar(style: .standard(title: L10n.walletPaymentMethodsTitle))
    }
}
