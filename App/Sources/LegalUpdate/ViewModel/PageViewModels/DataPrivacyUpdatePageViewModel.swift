import SwiftUI

class DataPrivacyUpdatePageViewModel: LegalUpdatePageViewModel {

    let legalManager: LegalManager

    init(legalManager: LegalManager = .init()) {
        self.legalManager = legalManager

        super.init(title: L10n.legalUpdatePrivacyTitle,
                   description: L10n.dataPrivacyUpdateDescriptionMarkdown)
    }

    override func setupPageActions() {
        pageActions = [
            .init(title: L10n.commonUseAccept, action: { [weak self] in
                self?.legalManager.accept(.dataPrivacy, for: LegalManager.Kind.dataPrivacy.acceptedLanguage ?? SystemManager.languageCode)
                self?.finishLegalUpdatePage()
            })
        ]
    }

    override func handleLinks(_ url: URL) -> OpenURLAction.Result {
        switch url.absoluteString {
        case Constants.Onboarding.dataPrivacyURL:
            webView = WebView(htmlString: SystemManager.loadHTMLFromBundle(fileName: LegalManager.Kind.dataPrivacy.fileName,
                                                                           for: LegalManager.Kind.dataPrivacy.acceptedLanguage ?? SystemManager.languageCode))

        default:
            break
        }

        return .handled
    }
}
