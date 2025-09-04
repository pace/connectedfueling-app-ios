import SwiftUI

// swiftlint:disable type_name
class OnboardingLocationPermissionPageViewModel: OnboardingPageViewModel {
    private let locationManager: LocationManager

    init(style: ConfigurationManager.Configuration.OnboardingStyle,
         locationManager: LocationManager = .shared) {
        self.locationManager = locationManager

        super.init(style: style,
                   image: .onboardingLocationIcon,
                   title: L10n.onboardingLocationPermissionTitle,
                   description: L10n.onboardingLocationPermissionDescription,
                   accessibilityString: AccessibilityIdentifiers.onboardingLocationPermissionTitle)
    }

    override func setupPageActions() {
        pageActions = [
            .init(title: L10n.commonUseNext, action: { [weak self] in
                self?.requestLocationPermission()
            }, accessibilityString: AccessibilityIdentifiers.commonUseNext)
        ]
    }

    override func isPageAlreadyCompleted() async -> Bool {
        locationManager.currentLocationPermissionStatus != .notDetermined
    }

    private func requestLocationPermission() {
        let currentStatus = locationManager.currentLocationPermissionStatus

        switch currentStatus {
        case .notDetermined:
            locationManager.requestLocationPermission { [weak self] _ in
                self?.finishOnboardingPage()
            }

        default:
            self.finishOnboardingPage()
        }
    }
}
