import SwiftUI

class OnboardingAnalyticsPageViewModel: OnboardingPageViewModel {
    init(style: ConfigurationManager.Configuration.OnboardingStyle) {
        let description = L10n.onboardingTrackingDescription
        let appTracking = L10n.onboardingTrackingAppTracking

        let appTrackingMarkdown = "[\(appTracking)](\(Constants.Onboarding.analyticsURL))"

        let descriptionMarkdown = description
            .replacingOccurrences(of: appTracking, with: appTrackingMarkdown)

        super.init(style: style,
                   image: .onboardingAnalyticsIcon,
                   title: L10n.onboardingTrackingTitle,
                   description: descriptionMarkdown)
    }

    override func setupPageActions() {
        pageActions = [
            .init(title: L10n.commonUseAccept, action: { [weak self] in
                CofuLogger.i("[OnboardingAnalyticsPageViewModel] Did accept app tracking")

                UserDefaults.isAnalyticsAllowed = true
                self?.finishOnboardingPage()
            }),
            .init(title: L10n.commonUseDecline, action: { [weak self] in
                CofuLogger.i("[OnboardingAnalyticsPageViewModel] Did decline app tracking")

                self?.finishOnboardingPage()
            })
        ]
    }

    override func handleLinks(_ url: URL) -> OpenURLAction.Result {
        switch url.absoluteString {
        case Constants.Onboarding.analyticsURL:
            webView = WebView(htmlString: SystemManager.loadHTMLFromBundle(fileName: Constants.File.analytics))

        default:
            break
        }

        return .handled
    }
}
