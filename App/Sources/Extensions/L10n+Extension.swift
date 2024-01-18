import Foundation

extension L10n {
    static var onboardingTrackingDescriptionMarkdown: String {
        let description = L10n.onboardingTrackingDescription
        let appTracking = L10n.onboardingTrackingAppTracking

        let appTrackingMarkdown = "[\(appTracking)](\(Constants.Onboarding.analyticsURL))"

        let descriptionMarkdown = description
            .replacingOccurrences(of: appTracking, with: appTrackingMarkdown)

        return descriptionMarkdown
    }
}
