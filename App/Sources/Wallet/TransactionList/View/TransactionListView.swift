import SwiftUI

struct TransactionListView: View {
    @ObservedObject var viewModel: TransactionListViewModel

    var body: some View {
        if viewModel.isLoading {
            loading
        } else {
            if viewModel.transactions.isEmpty {
                empty
            } else {
                content
            }
        }
    }

    @ViewBuilder
    private var content: some View {
        List(viewModel.transactions) { transaction in
            NavigationLink(destination: destination(for: transaction)) {
                TransactionCell(viewModel: transaction)
            }
        }
        .listStyle(.plain)
    }

    @ViewBuilder
    private var loading: some View {
        LoadingSpinner()
    }

    @ViewBuilder
    private var empty: some View {
        TextLabel(L10n.transactionsEmptyTitle)
    }

    private func destination(for transactionViewModel: TransactionDetailViewModel) -> some View {
        TransactionDetailView(viewModel: transactionViewModel)
            .addNavigationBar(style: .standard(title: L10n.transactionsDetailsTitle))
    }
}

#Preview {
    TransactionListView(viewModel: .init())
}
