import SwiftUI

struct OnboardingView: View {
    @StateObject private var viewModel: OnboardingViewModel = .init()
    @State private var currentPage = 0

    var body: some View {
        pageView
    }

    @ViewBuilder
    private var pageView: some View {
        PageView(numberOfPages: viewModel.pageViewModels.count, currentPage: $viewModel.currentPage) {
            ForEach(viewModel.pageViewModels) { viewModel in
                OnboardingPageView(viewModel: viewModel)
                    .padding(.bottom, 20)
            }
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
                .addNavigationBar(style: .centeredIcon(icon: .secondaryHeaderIcon))
        }
    }
}
