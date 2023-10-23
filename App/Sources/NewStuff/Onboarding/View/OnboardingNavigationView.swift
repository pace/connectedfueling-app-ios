import SwiftUI

struct OnboardingNavigationView: View {
    @ObservedObject private var onboardingViewModel: OnboardingViewModel

    init(onboardingViewModel: OnboardingViewModel) {
        self.onboardingViewModel = onboardingViewModel
    }

    var body: some View {
        AppNavigationView {
            OnboardingView(viewModel: onboardingViewModel)
                .addNavigationBar()
        }
    }
}
