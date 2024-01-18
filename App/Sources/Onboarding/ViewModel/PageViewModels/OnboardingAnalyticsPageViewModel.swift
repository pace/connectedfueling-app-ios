import SwiftUI

class OnboardingAnalyticsPageViewModel: OnboardingPageViewModel {
    let analyticsManager: AnalyticsManager

    init(style: ConfigurationManager.Configuration.OnboardingStyle,
         analyticsManager: AnalyticsManager) {
        self.analyticsManager = analyticsManager

        super.init(style: style,
                   image: .onboardingAnalyticsIcon,
                   title: L10n.onboardingTrackingTitle,
                   description: L10n.onboardingTrackingDescriptionMarkdown)
    }

    override func setupPageActions() {
        pageActions = [
            .init(title: L10n.commonUseAccept, action: { [weak self] in
                CofuLogger.i("[OnboardingAnalyticsPageViewModel] Did accept app tracking")

                UserDefaults.isAnalyticsAllowed = true
                self?.analyticsManager.updateActivationState()
                self?.sendAppInstalledEvent()
                self?.finishOnboardingPage()
            }),
            .init(title: L10n.commonUseDecline, action: { [weak self] in
                CofuLogger.i("[OnboardingAnalyticsPageViewModel] Did decline app tracking")

                UserDefaults.isAnalyticsAllowed = false
                self?.analyticsManager.updateActivationState()
                self?.finishOnboardingPage()
            })
        ]
    }

    func sendAppInstalledEvent() {
        guard !UserDefaults.firstStart else { return }
        analyticsManager.logEvent(AnalyticEvents.AppInstalledEvent())
        UserDefaults.firstStart = true
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
