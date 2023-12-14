import SwiftUI

struct OnboardingView: View {
    @StateObject private var viewModel: OnboardingViewModel = .init()

    var body: some View {
        OnboardingPagerView(onboardingPageViewModels: viewModel.pageViewModels,
                            currentPageIndex: $viewModel.currentPage)
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
