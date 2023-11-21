import SwiftUI

struct PaymentMethodsView: View {
    @StateObject private var viewModel: PaymentMethodsViewModel = .init()

    var body: some View {
        content
            .navigationTitle(L10n.paymentMethodsTitle)
            .onAppear {
                viewModel.fetchPaymentMethods()
            }
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading {
            loadingView
        } else if let error = viewModel.error {
            errorView(with: error)
        } else {
            paymentMethodsList
        }
    }

    @ViewBuilder
    private var loadingView: some View {
        VStack(spacing: 0) {
            LoadingView(title: L10n.paymentMethodsLoadingTitle,
                        description: L10n.paymentMethodsLoadingDescription)
            Spacer()
        }
        .padding([.top, .horizontal], 20)
    }

    @ViewBuilder
    private var paymentMethodsList: some View {
        VStack(spacing: 0) {
            PaymentMethodsListView(viewModel: viewModel)
            Spacer()
            ActionButton(title: L10n.paymentMethodsAddButton, style: .secondary) {
                viewModel.showPaymentApp()
            }
            .padding(.horizontal, 20)
        }
        .padding(.bottom, 10)
        .sheet(item: $viewModel.paymentAppUrlString) { urlString in
            AppView(urlString: urlString) {
                viewModel.fetchPaymentMethods()
            }
        }
    }

    @ViewBuilder
    func errorView(with error: AppError) -> some View {
        VStack(spacing: 0) {
            ErrorView(error)
            Spacer()
        }
        .padding([.top, .horizontal], 20)
    }
}

#Preview {
    NavigationView {
        PaymentMethodsView()
            .addNavigationBar(showsLogo: false, navigationTitle: L10n.paymentMethodsTitle)
    }
}
