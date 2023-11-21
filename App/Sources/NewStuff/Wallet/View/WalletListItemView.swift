import SwiftUI

struct WalletListItemView: View {
    @ObservedObject private var viewModel: WalletListItemViewModel

    init(viewModel: WalletListItemViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        HStack(spacing: 0) {
            Image(viewModel.icon)
                .frame(width: 19, height: 19, alignment: .center)
                .padding(.trailing, 14)
            switch viewModel.navigationType {
            case .appPresentation(let urlString):
                appPresentationContent
                    .sheet(isPresented: $viewModel.isPresentingApp) {
                        AppView(urlString: urlString)
                    }

            case .detail(let destination):
                detailContent(with: destination)
            }
            Spacer()
            DisclosureIndicator()
        }
    }

    @ViewBuilder
    private var titleLabel: some View {
        TextLabel(viewModel.title)
            .font(.system(size: 16, weight: .medium))
    }

    @ViewBuilder
    private var appPresentationContent: some View {
        Button {
            viewModel.presentApp()
        } label: {
            titleLabel
        }
    }

    @ViewBuilder
    private func detailContent(with destination: some View) -> some View {
        ZStack(alignment: .leading) {
            NavigationLink(destination: destination) {
                EmptyView()
            }.opacity(0)
            titleLabel
        }
    }
}

#Preview {
    NavigationView {
        VStack {
            WalletListItemView(viewModel: .init(icon: .walletTabItem,
                                                title: "Payment methods",
                                                navigationType: .appPresentation(urlString: "")))
            WalletListItemView(viewModel: .init(icon: .walletTabItem,
                                                title: "Payment methods",
                                                navigationType: .detail(destination: AnyView(
                                                    Text("")
                                                ))))
        }.addNavigationBar()
    }
}
