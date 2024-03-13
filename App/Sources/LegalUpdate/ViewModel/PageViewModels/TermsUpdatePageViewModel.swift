import SwiftUI

class TermsUpdatePageViewModel: LegalUpdatePageViewModel {

    let legalManager: LegalManager

    init(legalManager: LegalManager = .init()) {
        self.legalManager = legalManager

        super.init(title: L10n.legalUpdateTermsTitle,
                   description: L10n.termsUpdateDescriptionMarkdown)
    }

    override func setupPageActions() {
        pageActions = [
            .init(title: L10n.commonUseAccept, action: { [weak self] in
                self?.legalManager.accept(.terms, for: LegalManager.Kind.tracking.acceptedLanguage ?? SystemManager.languageCode)
                self?.finishLegalUpdatePage()
            })
        ]
    }

    override func handleLinks(_ url: URL) -> OpenURLAction.Result {
        switch url.absoluteString {
        case Constants.Onboarding.termsOfUseURL:
            webView = WebView(htmlString: SystemManager.loadHTMLFromBundle(fileName: LegalManager.Kind.terms.fileName,
                                                                           for: LegalManager.Kind.tracking.acceptedLanguage ?? SystemManager.languageCode))

        default:
            break
        }

        return .handled
    }
}
