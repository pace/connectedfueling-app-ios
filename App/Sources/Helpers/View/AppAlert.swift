import SwiftUI

enum AppAlert {
    static var genericError: Alert {
        Alert(title: Text("Oops, something went wrong"), // TODO: - Localized String
              message: Text(L10n.commonUseRetry))
    }

    static var locationPermissionDeniedError: Alert {
        Alert(title: Text(L10n.alertLocationPermissionDeniedTitle),
              primaryButton: .default(Text(L10n.Alert.LocationPermission.Actions.openSettings),
                                      action: {
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(url)
        }),
              secondaryButton: .cancel())
    }

    static var disableLocationPermission: Alert {
        Alert(title: Text(L10n.alertLocationPermissionDisabledTitle),
              primaryButton: .default(Text(L10n.Alert.LocationPermission.Actions.openSettings),
                                      action: {
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(url)
        }),
              secondaryButton: .cancel())
    }

    static var notificationPermissionDeniedError: Alert {
        Alert(title: Text(L10n.alertNotificationPermissionDeniedTitle),
              primaryButton: .default(Text(L10n.Alert.LocationPermission.Actions.openSettings),
                                      action: {
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(url)
        }),
              secondaryButton: .cancel())
    }

    static var disableNotificationPermission: Alert {
        Alert(title: Text(L10n.alertNotificationPermissionDisabledTitle),
              primaryButton: .default(Text(L10n.Alert.LocationPermission.Actions.openSettings),
                                      action: {
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(url)
        }),
              secondaryButton: .cancel())
    }

    static var locationServicesDisabledError: Alert {
        Alert(title: Text(L10n.LocationDialog.disabledTitle),
              message: Text(L10n.LocationDialog.disabledText),
              primaryButton: .default(Text(L10n.Alert.LocationPermission.Actions.openSettings),
                                      action: {
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(url)
        }),
              secondaryButton: .cancel())
    }

    static func networkError(retryAction: @escaping () -> Void) -> Alert {
        Alert(title: Text(L10n.commonUseNetworkError),
              primaryButton: .default(Text(L10n.commonUseRetry),
                                      action: retryAction),
              secondaryButton: .cancel())
    }

    static func logout(logoutAction: @escaping () -> Void) -> Alert {
        Alert(title: Text(L10n.Dashboard.Logout.Confirm.title),
              message: Text(L10n.Dashboard.Logout.Confirm.description),
              primaryButton: .default(Text(L10n.Dashboard.Logout.Confirm.Action.logout),
                                      action: logoutAction),
              secondaryButton: .cancel(Text(L10n.commonUseCancel)))
    }

    static func confirmation(title: String) -> Alert {
        Alert(title: Text(title))
    }

    static func disabledBiometricAuthentication(disableAction: @escaping () -> Void,
                                                cancelAction: @escaping () -> Void) -> Alert {
        Alert(title: Text(L10n.commonUseAreYouSure),
              primaryButton: .destructive(Text(L10n.commonUseDeactivate),
                                      action: disableAction),
              secondaryButton: .cancel(Text(L10n.commonUseCancel),
                                       action: cancelAction))
    }
}
