import SwiftUI

struct WalletListView: View {
    @ObservedObject private var viewModel: WalletViewModel

    init(viewModel: WalletViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        List(viewModel.listItems) { listItem in
            WalletListItemView(viewModel: listItem)
        }
        .listStyle(.plain)
    }
}

#Preview {
    WalletListView(viewModel: .init())
}
