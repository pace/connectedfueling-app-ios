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
                   description: L10n.onboardingLocationPermissionDescription)
    }

    override func setupPageActions() {
        pageActions = [
            .init(title: L10n.onboardingLocationPermissionAction, action: { [weak self] in
                self?.requestLocationPermission()
            })
        ]
    }

    override func isPageAlreadyCompleted() async -> Bool {
        await locationManager.currentLocationPermissionStatus() == .authorized
    }

    private func requestLocationPermission() {
        Task { @MainActor [weak self] in
            guard let currentStatus = await self?.locationManager.currentLocationPermissionStatus() else { return }

            switch currentStatus {
            case .notDetermined:
                self?.locationManager.requestLocationPermission { [weak self] status in
                    guard status == .authorized else { return }
                    self?.finishOnboardingPage()
                }

            case .denied:
                self?.alert = AppAlert.locationPermissionError

            case .authorized:
                self?.finishOnboardingPage()
            }
        }
    }
}
