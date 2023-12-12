// Copyright © 2023 PACE Telematics GmbH. All rights reserved.

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
            NavigationLink(destination: TransactionDetailView(viewModel: transaction)) {
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
        TextLabel("Noch keine Transaktionen") // TODO: string / design
    }
}

#Preview {
    TransactionListView(viewModel: .init())
}
