import SwiftUI

struct ConsentUpdatePageView: View {

    @ObservedObject private var viewModel: ConsentUpdatePageViewModel

    init(viewModel: ConsentUpdatePageViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        content
            .sheet(item: $viewModel.webView) { webView in
                webView
            }
    }

    @ViewBuilder
    private var content: some View {
        VStack(spacing: 0) {
            Spacer()
            pageContent
            Spacer()
            actionButtons
        }
    }

    @ViewBuilder
    private var pageContent: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                Image(.warningIcon)
                    .frame(width: 42, height: 42)
                TextLabel(viewModel.title, alignment: .center)
                    .font(.system(size: 20, weight: .bold))
                    .padding(.top, .paddingM)
                    .padding(.horizontal, .paddingM)
                TextLabel(viewModel.description, alignment: .center)
                    .font(.system(size: 16, weight: .regular))
                    .padding([.horizontal, .top], .paddingM)
            }
            .environment(\.openURL, OpenURLAction(handler: viewModel.handleLinks))
        }
    }

    @ViewBuilder
    private var actionButtons: some View {
        VStack(spacing: .paddingXS) {
            ForEach(viewModel.pageActions.reversed()) { pageAction in
                ActionButton(title: pageAction.title,
                             style: pageAction == viewModel.pageActions.first ? .primary : .secondary,
                             action: pageAction.action)
                .padding(.horizontal, .paddingM)
            }
        }
    }
}

#Preview {
    ConsentUpdatePageView(viewModel: TermsUpdatePageViewModel())
}
