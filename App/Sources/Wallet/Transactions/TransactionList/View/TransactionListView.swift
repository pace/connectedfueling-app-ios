import SwiftUI

struct TransactionListView: View {
    @StateObject var viewModel: TransactionListViewModel = .init()

    var body: some View {
        ScrollView {
            content
                .navigationTitle(L10n.walletTransactionsTitle)
                .refreshable(action: viewModel.refresh)
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .initialLoading:
            loadingView

        case .hasNextPage(let transactions),
                .loadingNextPage(let transactions):
            transactionList(with: transactions, hasNextPage: true)

        case .loadedAllPages(let transactions):
            transactionList(with: transactions, hasNextPage: false)

        case .failure(let transactions, _) where transactions != nil:
            if let transactions {
                transactionList(with: transactions, hasNextPage: false)
            } else if let error = viewModel.error {
                errorView(with: error)
            }

        default:
            let error = viewModel.error ?? .init(title: L10n.commonUseErrorTitle,
                                                 description: L10n.commonUseErrorDescription,
                                                 retryAction: .init(title: L10n.commonUseRetry, action: {
                Task {
                    await viewModel.refresh()
                }
            }))
            errorView(with: error)
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
    private func transactionList(with transactions: [TransactionDetailViewModel],
                                 hasNextPage: Bool) -> some View {
        TransactionList(transactions: transactions,
                        hasNextPage: hasNextPage,
                        showBusinessBadge: false,
                        onLoadNextPage: { viewModel.loadNextPageIfNeeded() })
        .padding(.horizontal)
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
