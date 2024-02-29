import Foundation

extension L10n {

    static var onboardingLegalDescriptionMarkdown: String {
        let description = L10n.onboardingLegalDescription
        let termsOfUse = L10n.onboardingLegalTermsOfUse
        let dataPrivacy = L10n.onboardingLegalDataPrivacy

        let termsOfUseMarkdown = "[\(termsOfUse)](\(Constants.Onboarding.termsOfUseURL))"
        let dataPrivacyMarkdown = "[\(dataPrivacy)](\(Constants.Onboarding.dataPrivacyURL))"

        return description
            .replacingOccurrences(of: termsOfUse, with: termsOfUseMarkdown)
            .replacingOccurrences(of: dataPrivacy, with: dataPrivacyMarkdown)
    }

    static var onboardingTrackingDescriptionMarkdown: String {
        let description = L10n.onboardingTrackingDescription
        let appTracking = L10n.onboardingTrackingAppTracking

        let appTrackingMarkdown = "[\(appTracking)](\(Constants.Onboarding.analyticsURL))"

        let descriptionMarkdown = description
            .replacingOccurrences(of: appTracking, with: appTrackingMarkdown)

        return descriptionMarkdown
    }

    static var termsUpdateDescriptionMarkdown: String {
        let description = L10n.legalUpdateTermsDescription
        let termsOfUse = L10n.onboardingLegalTermsOfUse

        let termsOfUseMarkdown = "[\(termsOfUse)](\(Constants.Onboarding.termsOfUseURL))"

        return description
            .replacingOccurrences(of: termsOfUse, with: termsOfUseMarkdown)
    }

    static var dataPrivacyUpdateDescriptionMarkdown: String {
        let description = L10n.legalUpdatePrivacyDescription
        let dataPrivacy = L10n.onboardingLegalDataPrivacy

        let termsOfUseMarkdown = "[\(dataPrivacy)](\(Constants.Onboarding.dataPrivacyURL))"

        return description
            .replacingOccurrences(of: dataPrivacy, with: termsOfUseMarkdown)
    }

    static var trackingUpdateDescriptionMarkdown: String {
        let description = L10n.legalUpdateTrackingDescription
        let appTracking = L10n.onboardingTrackingAppTracking

        let appTrackingMarkdown = "[\(appTracking)](\(Constants.Onboarding.analyticsURL))"

        return description
            .replacingOccurrences(of: appTracking, with: appTrackingMarkdown)
    }
}
