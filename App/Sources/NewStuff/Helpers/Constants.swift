import Foundation

enum Constants {
    static let otpDigitsCount: Int = 6
    static let pinDigitsCount: Int = 4

    enum View {
        static let defaultButtonPadding: CGFloat = 35
        static let defaultTitleLabelPadding: CGFloat = 30
        static let defaultDescriptionLabelPadding: CGFloat = 60
    }

    enum UserDefaults {
        static let isOnboardingCompleted: String = "car.pace.ConnectedFueling.isOnboardingCompleted"
        static let fuelType: String = "car.pace.ConnectedFueling.fuelType"
    }

    enum Distance {
        static let formattingThresholdForMetersPrecision: Double = 1.0
        static let formattingThresholdInKm: Double = 10.0
        static let roundingThreshold: Double = 0.05
    }

    enum GasStationList {
        static let cofuStationRadius: Double = 10_000
        static let updateDistanceThresholdInMeters: Double = 500
        static let priceFormatFallback: String = "d.dds"
    }

    enum CrashReporting {
        static let sentryDSNInfoPlistKey = "SentryDSN"
    }
}
