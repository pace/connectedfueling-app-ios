import SwiftUI

struct TransactionList: View {
    let transactions: [TransactionDetailViewModel]
    let hasNextPage: Bool
    let showBusinessBadge: Bool

    let onLoadNextPage: () -> Void

    var body: some View {
        LazyVStack {
            ForEach(Array(transactions.enumerated()), id: \.element.id) { index, transaction in
                NavigationLink(destination: destination(for: transaction)) {
                    TransactionCell(viewModel: transaction)
                }

                if index < transactions.count - 1 {
                    Divider()
                }
            }

            if hasNextPage {
                LoadingSpinner()
                    .frame(width: 25, height: 25)
                    .onAppear {
                        onLoadNextPage()
                    }
            }
        }
    }

    private func destination(for transactionViewModel: TransactionDetailViewModel) -> some View {
        TransactionDetailView(viewModel: transactionViewModel)
            .addNavigationBar(style: .standard(title: L10n.transactionsDetailsTitle))
    }
}
