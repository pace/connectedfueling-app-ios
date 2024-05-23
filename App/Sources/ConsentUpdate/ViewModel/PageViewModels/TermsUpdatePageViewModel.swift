import SwiftUI

class TermsUpdatePageViewModel: ConsentUpdatePageViewModel {

    let consentManager: ConsentManager

    init(consentManager: ConsentManager = .init()) {
        self.consentManager = consentManager

        super.init(title: L10n.legalUpdateTermsTitle,
                   description: L10n.termsUpdateDescriptionMarkdown)
    }

    override func setupPageActions() {
        pageActions = [
            .init(title: L10n.commonUseAccept, action: { [weak self] in
                self?.consentManager.accept(.terms, for: ConsentManager.Kind.tracking.acceptedLanguage ?? SystemManager.languageCode)
                self?.finishConsentUpdatePage()
            })
        ]
    }

    override func handleLinks(_ url: URL) -> OpenURLAction.Result {
        switch url.absoluteString {
        case Constants.Onboarding.termsOfUseURL:
            webView = WebView(htmlString: SystemManager.loadHTMLFromBundle(fileName: ConsentManager.Kind.terms.fileName,
                                                                           for: ConsentManager.Kind.tracking.acceptedLanguage ?? SystemManager.languageCode))

        default:
            break
        }

        return .handled
    }
}
