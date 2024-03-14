import SwiftUI

class TrackingUpdatePageViewModel: ConsentUpdatePageViewModel {
    let analyticsManager: AnalyticsManager
    let consentManager: ConsentManager

    init(consentManager: ConsentManager = .init(),
         analyticsManager: AnalyticsManager) {
        self.consentManager = consentManager
        self.analyticsManager = analyticsManager

        super.init(title: L10n.legalUpdateTrackingTitle,
                   description: L10n.trackingUpdateDescriptionMarkdown)
    }

    override func setupPageActions() {
        pageActions = [
            .init(title: L10n.commonUseAccept, action: { [weak self] in
                CofuLogger.i("[TrackingUpdatePageViewModel] Did accept app tracking")

                UserDefaults.isAnalyticsAllowed = true
                UserDefaults.didAskForAnalytics = true
                self?.consentManager.accept(.tracking, for: ConsentManager.Kind.tracking.acceptedLanguage ?? SystemManager.languageCode)
                self?.analyticsManager.updateActivationState()
                self?.finishConsentUpdatePage()
            }),
            .init(title: L10n.commonUseDecline, action: { [weak self] in
                CofuLogger.i("[TrackingUpdatePageViewModel] Did decline app tracking")

                UserDefaults.isAnalyticsAllowed = false
                UserDefaults.didAskForAnalytics = true
                self?.analyticsManager.updateActivationState()
                self?.finishConsentUpdatePage()
            })
        ]
    }

    override func handleLinks(_ url: URL) -> OpenURLAction.Result {
        switch url.absoluteString {
        case Constants.Onboarding.analyticsURL:
            webView = WebView(htmlString: SystemManager.loadHTMLFromBundle(fileName: ConsentManager.Kind.tracking.fileName,
                                                                           for: ConsentManager.Kind.tracking.acceptedLanguage ?? SystemManager.languageCode))

        default:
            break
        }

        return .handled
    }
}
