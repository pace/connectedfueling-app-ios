import SwiftUI

class OnboardingLegalPageViewModel: OnboardingPageViewModel {

    let legalManager: LegalManager

    init(style: ConfigurationManager.Configuration.OnboardingStyle, legalManager: LegalManager = .init()) {
        self.legalManager = legalManager

        super.init(style: style,
                   image: .onboardingLegalIcon,
                   title: L10n.onboardingLegalTitle,
                   description: L10n.onboardingLegalDescriptionMarkdown)
    }

    override func setupPageActions() {
        pageActions = [
            .init(title: L10n.commonUseAccept, action: { [weak self] in
                self?.legalManager.accept(.terms, for: SystemManager.languageCode)
                self?.legalManager.accept(.dataPrivacy, for: SystemManager.languageCode)
                self?.finishOnboardingPage()
            })
        ]
    }

    override func handleLinks(_ url: URL) -> OpenURLAction.Result {
        let htmlFileName: String? = switch url.absoluteString {
        case Constants.Onboarding.termsOfUseURL:
            LegalManager.Kind.terms.fileName

        case Constants.Onboarding.dataPrivacyURL:
            LegalManager.Kind.dataPrivacy.fileName

        default:
            nil
        }

        guard let htmlFileName else {
            CofuLogger.e("[OnboardingLegalPageViewModel] Failed handling link for url \(url)")
            return .handled
        }

        webView = WebView(htmlString: SystemManager.loadHTMLFromBundle(fileName: htmlFileName, for: SystemManager.languageCode))
        return .handled
    }
}
