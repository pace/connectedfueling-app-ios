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
}
