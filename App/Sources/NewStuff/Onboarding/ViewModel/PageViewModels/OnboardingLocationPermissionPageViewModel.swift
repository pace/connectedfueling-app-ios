import SwiftUI

// swiftlint:disable type_name
class OnboardingLocationPermissionPageViewModel: OnboardingPageViewModel {
    private let locationManager: LocationManager

    init(locationManager: LocationManager = .init()) {
        self.locationManager = locationManager

        super.init(image: .location,
                   title: L10n.onboardingPermissionTitle,
                   description: L10n.onboardingPermissionDescription)
    }

    override func setupPageActions() {
        pageActions = [
            .init(title: L10n.onboardingPermissionAction, action: { [weak self] in
                self?.requestLocationPermission()
            })
        ]
    }

    override func checkPreconditions() {
        super.checkPreconditions()
        fetchLocationPermissionStatus()
    }

    private func fetchLocationPermissionStatus() {
        Task { @MainActor [weak self] in
            guard await self?.locationManager.currentLocationPermissionStatus() == .authorized else { return }
            self?.finishOnboardingPage()
        }
    }

    private func requestLocationPermission() {
        locationManager.requestLocationPermission { [weak self] status in
            guard status == .authorized else { return }
            self?.finishOnboardingPage()
        }
    }
}
