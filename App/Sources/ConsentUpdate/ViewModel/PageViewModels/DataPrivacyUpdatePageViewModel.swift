import SwiftUI

class DataPrivacyUpdatePageViewModel: ConsentUpdatePageViewModel {

    let consentManager: ConsentManager

    init(consentManager: ConsentManager = .init()) {
        self.consentManager = consentManager

        super.init(title: L10n.legalUpdatePrivacyTitle,
                   description: L10n.dataPrivacyUpdateDescriptionMarkdown)
    }

    override func setupPageActions() {
        pageActions = [
            .init(title: L10n.commonUseAccept, action: { [weak self] in
                self?.consentManager.accept(.dataPrivacy, for: ConsentManager.Kind.dataPrivacy.acceptedLanguage ?? SystemManager.languageCode)
                self?.finishConsentUpdatePage()
            })
        ]
    }

    override func handleLinks(_ url: URL) -> OpenURLAction.Result {
        switch url.absoluteString {
        case Constants.Onboarding.dataPrivacyURL:
            webView = WebView(htmlString: SystemManager.loadHTMLFromBundle(fileName: ConsentManager.Kind.dataPrivacy.fileName,
                                                                           for: ConsentManager.Kind.dataPrivacy.acceptedLanguage ?? SystemManager.languageCode))

        default:
            break
        }

        return .handled
    }
}
