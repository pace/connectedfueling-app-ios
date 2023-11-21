import SwiftUI

struct PaymentMethodsListView: View {
    @ObservedObject private var viewModel: PaymentMethodsViewModel

    init(viewModel: PaymentMethodsViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        if viewModel.paymentMethodViewModels.isEmpty {
            emptyView
        } else {
            paymentMethodsList
        }
    }

    @ViewBuilder
    private var emptyView: some View {
        ErrorView(viewModel.emptyPaymentMethodsError)
            .padding([.top, .horizontal], 20)
    }

    @ViewBuilder
    private var paymentMethodsList: some View {
        List(viewModel.paymentMethodViewModels) { paymentMethodViewModel in
            PaymentMethodsListItemView(viewModel: paymentMethodViewModel)
        }
        .listStyle(.plain)
    }
}

#Preview {
    PaymentMethodsListView(viewModel: .init())
}
