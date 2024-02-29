import SwiftUI

class TrackingUpdatePageViewModel: LegalUpdatePageViewModel {
    let analyticsManager: AnalyticsManager
    let legalManager: LegalManager

    init(legalManager: LegalManager = .init(),
         analyticsManager: AnalyticsManager) {
        self.legalManager = legalManager
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
                self?.legalManager.accept(.tracking, for: LegalManager.Kind.tracking.acceptedLanguage ?? SystemManager.languageCode)
                self?.analyticsManager.updateActivationState()
                self?.finishLegalUpdatePage()
            }),
            .init(title: L10n.commonUseDecline, action: { [weak self] in
                CofuLogger.i("[TrackingUpdatePageViewModel] Did decline app tracking")

                UserDefaults.isAnalyticsAllowed = false
                UserDefaults.didAskForAnalytics = true
                self?.analyticsManager.updateActivationState()
                self?.finishLegalUpdatePage()
            })
        ]
    }

    override func handleLinks(_ url: URL) -> OpenURLAction.Result {
        switch url.absoluteString {
        case Constants.Onboarding.analyticsURL:
            webView = WebView(htmlString: SystemManager.loadHTMLFromBundle(fileName: LegalManager.Kind.tracking.fileName,
                                                                           for: LegalManager.Kind.tracking.acceptedLanguage ?? SystemManager.languageCode))

        default:
            break
        }

        return .handled
    }
}
