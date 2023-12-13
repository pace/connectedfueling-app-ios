import Foundation

enum Constants {
    static let otpDigitsCount: Int = 6
    static let pinDigitsCount: Int = 4
    static let applePayKind: String = "applepay"
    static let jwtEmailKey: String = "email"
    static let fallbackLanguageCode: String = "en"

    enum View {
        static let defaultButtonPadding: CGFloat = 35
        static let defaultTitleLabelPadding: CGFloat = 30
        static let defaultDescriptionLabelPadding: CGFloat = 60
    }

    enum UserDefaults {
        static let migrationVersion: String = "migrationVersion"
        static let isOnboardingCompleted: String = "isOnboardingCompleted"
        static let fuelType: String = "fuelType"
        static let isAnalyticsAllowed: String = "isAnalyticsAllowed"
    }

    enum Distance {
        static let formattingThresholdForMetersPrecision: Double = 1.0
        static let formattingThresholdInKm: Double = 10.0
        static let roundingThreshold: Double = 0.05
    }

    enum GasStation {
        static let cofuStationRadius: Double = 50_000
        static let updateDistanceThresholdInMeters: Double = 500
        static let priceFormatFallback: String = "d.dds"
    }

    enum Map {
        static let mapSpanDelta: Double = 0.01 // TODO: decide delta value
        static let updateDistanceThresholdInMeters: Double = 500
    }

    enum CrashReporting {
        static let sentryDSNInfoPlistKey = "SentryDSN"
    }

    enum FuelTypeFilter {
        static let defaultFuelType: FuelType = .cheapestPetrol
    }

    enum File {
        static let configuration: String = "configuration"
        static let termsOfUse: String = "terms"
        static let dataPrivacy: String = "privacy"
        static let imprint: String = "imprint"
        static let analytics: String = "analytics"
    }

    enum Onboarding {
        static let termsOfUseURL: String = "terms_of_use"
        static let dataPrivacyURL: String = "data_privacy"
        static let analyticsURL: String = "analytics"
    }
}
