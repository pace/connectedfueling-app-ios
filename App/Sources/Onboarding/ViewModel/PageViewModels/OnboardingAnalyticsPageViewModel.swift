import SwiftUI

class OnboardingAnalyticsPageViewModel: OnboardingPageViewModel {
    let analyticsManager: AnalyticsManager
    let legalManager: ConsentManager

    init(style: ConfigurationManager.Configuration.OnboardingStyle,
         analyticsManager: AnalyticsManager,
         legalManager: ConsentManager = .init()) {
        self.analyticsManager = analyticsManager
        self.legalManager = legalManager

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
                UserDefaults.didAskForAnalytics = true
                self?.legalManager.accept(.tracking, for: SystemManager.languageCode)
                self?.analyticsManager.updateActivationState()
                self?.sendAppInstalledEvent()
                self?.finishOnboardingPage()
            }),
            .init(title: L10n.commonUseDecline, action: { [weak self] in
                CofuLogger.i("[OnboardingAnalyticsPageViewModel] Did decline app tracking")

                UserDefaults.isAnalyticsAllowed = false
                UserDefaults.didAskForAnalytics = true
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
            webView = WebView(htmlString: SystemManager.loadHTMLFromBundle(fileName: ConsentManager.Kind.tracking.fileName, for: SystemManager.languageCode))

        default:
            break
        }

        return .handled
    }
}
