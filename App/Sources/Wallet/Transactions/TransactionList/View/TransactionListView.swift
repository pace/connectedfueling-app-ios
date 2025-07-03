import SwiftUI

struct TransactionListView: View {
    @StateObject var viewModel: TransactionListViewModel = .init()

    var body: some View {
        VStack {
            content
        }
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading {
            loadingView
        } else if let error = viewModel.error {
            errorView(with: error)
        } else if viewModel.transactions.isEmpty {
            emptyView
        } else {
            transactionsList
        }
    }

    @ViewBuilder
    private var loadingView: some View {
        VStack(spacing: 0) {
            LoadingView(title: L10n.transactionsLoadingTitle)
            Spacer()
        }
        .padding([.top, .horizontal], .paddingM)
    }

    @ViewBuilder
    private var emptyView: some View {
        VStack(spacing: 0) {
            ErrorView(viewModel.emptyTransactionsError)
            Spacer()
        }
        .padding([.top, .horizontal], .paddingM)
    }

    @ViewBuilder
    private var transactionsList: some View {
        List(viewModel.transactions) { transaction in
            NavigationLink(destination: destination(for: transaction)) {
                TransactionCell(viewModel: transaction)
            }
        }
        .listStyle(.plain)
    }

    @ViewBuilder
    func errorView(with error: AppError) -> some View {
        VStack(spacing: 0) {
            ErrorView(error)
            Spacer()
        }
        .padding([.top, .horizontal], .paddingM)
    }

    private func destination(for transactionViewModel: TransactionDetailViewModel) -> some View {
        TransactionDetailView(viewModel: transactionViewModel)
            .addNavigationBar(style: .standard(title: L10n.transactionsDetailsTitle))
    }
}

#Preview {
    TransactionListView(viewModel: .init())
}
