import SwiftUI

struct MenuAnalyticsView: View {
    @StateObject private var viewModel: MenuAnalyticsViewModel

    init(analyticsManager: AnalyticsManager) {
        self._viewModel = .init(wrappedValue: .init(analyticsManager: analyticsManager))
    }

    var body: some View {
        content
            .environment(\.openURL, OpenURLAction(handler: viewModel.handleLinks))
            .sheet(isPresented: $viewModel.isPresentingAnalytics) {
                WebView(htmlString: SystemManager.loadHTMLFromBundle(fileName: ConsentManager.Kind.tracking.fileName,
                                                                     for: ConsentManager.Kind.tracking.acceptedLanguage ?? SystemManager.languageCode))
            }
    }

    @ViewBuilder
    private var content: some View {
        VStack(spacing: 0) {
            Spacer()
            MenuAnalyticsStateView(isAnalyticsAllowed: $viewModel.isAnalyticsAllowed)
            Image(viewModel.analyticsIcon)
                .resizable()
                .frame(width: 182, height: 182)
                .foregroundColor(Color.lightGrey)
                .padding(.top, .paddingL)
            TextLabel(viewModel.title, alignment: .center)
                .font(.system(size: 20, weight: .bold))
                .padding(.top, .paddingL)
                .padding(.horizontal, .paddingM)
            TextLabel(viewModel.description, alignment: .center)
                .font(.system(size: 16, weight: .regular))
                .padding(.top, .paddingS)
                .padding(.horizontal, .paddingM)
            Spacer()
            ActionButton(title: viewModel.isAnalyticsAllowed ? L10n.commonUseDecline : L10n.commonUseAccept,
                         style: viewModel.isAnalyticsAllowed ? .secondary : .primary,
                         action: viewModel.didTapAnalyticsConsent)
            .padding(.horizontal, .paddingM)
            .padding(.bottom, .paddingXS)
        }
    }
}

#Preview {
    MenuAnalyticsView(analyticsManager: .init())
}
