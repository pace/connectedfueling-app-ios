import Foundation
import PACECloudSDK

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

    enum Distance {
        static let formattingThresholdForMetersPrecision: Double = 1000.0 // m
        static let formattingThresholdForKm: Double = 10000.0 // m
        static let roundingThreshold: Double = 50 // m
        static let cofuDistanceThreshold: Double = 250 // m
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
        static let termsOfUse: String = "usage_terms"
        static let dataPrivacy: String = "privacy_statement"
        static let imprint: String = "imprint"
        static let analytics: String = "usage_analysis"
    }

    enum Onboarding {
        static let termsOfUseURL: String = "terms_of_use"
        static let dataPrivacyURL: String = "data_privacy"
        static let analyticsURL: String = "analytics"
    }

    enum URL {
        static let paymentMethodCreation: String = "\(PACECloudSDK.URL.payment.absoluteString)/payment-create?redirect_uri=\(AppKit.Constants.appCloseRedirectUri)"
    }
}

extension Constants {
    static let currentEnvironment: PACECloudSDK.Environment = {
        #if SANDBOX
        return .sandbox
        #elseif DEVELOPMENT
        return .development
        #else
        return .production
        #endif
    }()
}
