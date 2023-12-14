import SwiftUI
import SwiftUIIntrospect

struct OnboardingView: View {
    @StateObject private var viewModel: OnboardingViewModel = .init()
    @State private var currentPage = 0

    var body: some View {
        pageView
    }

    @ViewBuilder
    private var pageView: some View {
        TabView(selection: $viewModel.currentPage) {
            ForEach(0..<viewModel.pageViewModels.count, id: \.self) { index in
                OnboardingPageView(viewModel: viewModel.pageViewModels[index])
                    .tag(index)
                    .padding(.bottom, .paddingM)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .edgesIgnoringSafeArea(.top)
        .animation(.default)
        .introspect(.scrollView, on: .iOS(.v15, .v16, .v17)) { scrollView in
            scrollView.isScrollEnabled = false
            scrollView.isPagingEnabled = true
        }
    }
}

#Preview {
    AppNavigationView {
        switch ConfigurationManager.configuration.onboardingStyle {
        case .primary:
            OnboardingView()

        case .secondary:
            OnboardingView()
                .addNavigationBar(style: .centeredIcon(icon: .brandIcon))
        }
    }
}
