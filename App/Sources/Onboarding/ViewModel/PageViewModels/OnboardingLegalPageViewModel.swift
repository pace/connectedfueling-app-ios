import SwiftUI

class OnboardingLegalPageViewModel: OnboardingPageViewModel {
    init(style: ConfigurationManager.Configuration.OnboardingStyle) {
        let description = L10n.onboardingLegalDescription
        let termsOfUse = L10n.onboardingLegalTermsOfUse
        let dataPrivacy = L10n.onboardingLegalDataPrivacy

        let termsOfUseMarkdown = "[\(termsOfUse)](\(Constants.Onboarding.termsOfUseURL))"
        let dataPrivacyMarkdown = "[\(dataPrivacy)](\(Constants.Onboarding.dataPrivacyURL))"

        let descriptionMarkdown = description
            .replacingOccurrences(of: termsOfUse, with: termsOfUseMarkdown)
            .replacingOccurrences(of: dataPrivacy, with: dataPrivacyMarkdown)

        super.init(style: style,
                   image: .onboardingLegalIcon,
                   title: L10n.onboardingLegalTitle,
                   description: descriptionMarkdown)
    }

    override func setupPageActions() {
        pageActions = [
            .init(title: L10n.commonUseAccept, action: { [weak self] in
                self?.finishOnboardingPage()
            })
        ]
    }

    override func handleLinks(_ url: URL) -> OpenURLAction.Result {
        let htmlFileName: String? = switch url.absoluteString {
        case Constants.Onboarding.termsOfUseURL:
            Constants.File.termsOfUse

        case Constants.Onboarding.dataPrivacyURL:
            Constants.File.dataPrivacy

        default:
            nil
        }

        guard let htmlFileName else {
            CofuLogger.e("[OnboardingLegalPageViewModel] Failed handling link for url \(url)")
            return .handled
        }

        webView = WebView(htmlString: SystemManager.loadHTMLFromBundle(fileName: htmlFileName))
        return .handled
    }
}
