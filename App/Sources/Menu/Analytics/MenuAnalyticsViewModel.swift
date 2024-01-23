import SwiftUI

class MenuAnalyticsViewModel: ObservableObject {
    @Published var isPresentingAnalytics: Bool = false
    @Published var isAnalyticsAllowed: Bool = false

    let analyticsIcon: ImageResource
    let title: String
    let description: String

    private let analyticsManager: AnalyticsManager

    init(analyticsManager: AnalyticsManager) {
        self.analyticsManager = analyticsManager
        self.analyticsIcon = .onboardingAnalyticsIcon
        self.title = L10n.onboardingTrackingTitle
        self.description = L10n.onboardingTrackingDescriptionMarkdown
        self.isAnalyticsAllowed = UserDefaults.isAnalyticsAllowed
    }

    func didTapAnalyticsConsent() {
        isAnalyticsAllowed.toggle()
        UserDefaults.isAnalyticsAllowed = isAnalyticsAllowed
        analyticsManager.updateActivationState()

        if isAnalyticsAllowed {
            CofuLogger.i("[MenuAnalyticsViewModel] Did accept app tracking")
        } else {
            CofuLogger.i("[MenuAnalyticsViewModel] Did decline app tracking")
        }
    }

    func handleLinks(_ url: URL) -> OpenURLAction.Result {
        switch url.absoluteString {
        case Constants.Onboarding.analyticsURL:
            isPresentingAnalytics = true

        default:
            break
        }

        return .handled
    }
}
