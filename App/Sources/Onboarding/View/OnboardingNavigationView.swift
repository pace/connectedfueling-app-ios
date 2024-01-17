import SwiftUI

struct OnboardingNavigationView: View {
    let analyticsManager: AnalyticsManager

    init(analyticsManager: AnalyticsManager) {
        self.analyticsManager = analyticsManager
    }

    var body: some View {
        AppNavigationView {
            switch ConfigurationManager.configuration.onboardingStyle {
            case .primary:
                OnboardingView(analyticsManager: analyticsManager)

            case .secondary:
                OnboardingView(analyticsManager: analyticsManager)
                    .addNavigationBar(style: .centeredIcon(icon: .secondaryHeaderIcon), backgroundColor: .primaryTint)
            }
        }
    }
}
