import SwiftUI

struct OnboardingNavigationView: View {
    var body: some View {
        AppNavigationView {
            switch ConfigurationManager.configuration.onboardingStyle {
            case .primary:
                OnboardingView()

            case .secondary:
                OnboardingView()
                    .addNavigationBar(style: .centeredIcon(icon: .brandIcon), backgroundColor: .primaryTint)
            }
        }
    }
}
