import SwiftUI

class MenuPermissionsViewModel: ObservableObject {
    @Published var isNotificationsEnabled: Bool = false
    @Published var isLocationEnabled: Bool = false
    @Published var alert: Alert?

    let showsNotificationSetting: Bool

    private let locationManager: LocationManager
    private let notificationManager: NotificationManager

    init(notificationManager: NotificationManager = .init(),
         locationManager: LocationManager = .shared,
         configuration: ConfigurationManager.Configuration = ConfigurationManager.configuration) {
        self.notificationManager = notificationManager
        self.locationManager = locationManager

        showsNotificationSetting = configuration.isAnalyticsEnabled

        refreshPermissions()
    }

    func refreshPermissions() {
        isLocationEnabled = locationManager.currentLocationPermissionStatus == .authorized

        Task { @MainActor [weak self] in
            self?.isNotificationsEnabled = await self?.notificationManager.currentNotificationPermissionStatus() == .authorized
        }
    }

    func didTapNotificationSetting(newValue: Bool) {
        Task { @MainActor [weak self] in
            guard let self = self else { return }

            let currentNotificationPermissionStatus = await self.notificationManager.currentNotificationPermissionStatus()

            switch (currentNotificationPermissionStatus, newValue) {
            case (.notDetermined, true):
                let isEnabled = await self.notificationManager.requestNotificationAuthorization()
                self.isNotificationsEnabled = isEnabled

            case (.authorized, false):
                self.alert = AppAlert.disableNotificationPermission

            case (.denied, true):
                self.alert = AppAlert.notificationPermissionDeniedError

            default:
                break
            }
        }
    }

    func didTapLocationSetting(newValue: Bool) {
        let currentLocationPermissionStatus = locationManager.currentLocationPermissionStatus

        switch (currentLocationPermissionStatus, newValue) {
        case (.notDetermined, true):
            locationManager.requestLocationPermission { [weak self] status in
                self?.isLocationEnabled = status == .authorized
            }

        case (.authorized, false):
            alert = AppAlert.disableLocationPermission

        case (.denied, true):
            alert = AppAlert.locationPermissionDeniedError

        case (.disabled, true):
            alert = AppAlert.locationServicesDisabledError

        default:
            break
        }
    }
}
