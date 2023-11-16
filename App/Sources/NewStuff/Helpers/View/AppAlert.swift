import SwiftUI

enum AppAlert {
    static var genericError: Alert {
        Alert(title: Text("Oops, something went wrong"),
              message: Text(L10n.commonRetry))
    }

    static var locationPermissionError: Alert {
        Alert(title: Text(L10n.Alert.LocationPermission.title),
              message: Text(L10n.Alert.LocationPermission.description),
              primaryButton: .default(Text(L10n.Alert.LocationPermission.Actions.openSettings),
                                      action: {
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(url)
        }),
              secondaryButton: .cancel())
    }

    static func networkError(retryAction: @escaping () -> Void) -> Alert {
        Alert(title: Text("No network connection"),
              primaryButton: .default(Text(L10n.commonRetry),
                                      action: retryAction),
              secondaryButton: .cancel())
    }

    static func logout(logoutAction: @escaping () -> Void) -> Alert {
        Alert(title: Text(L10n.Dashboard.Logout.Confirm.title),
              message: Text(L10n.Dashboard.Logout.Confirm.description),
              primaryButton: .default(Text(L10n.Dashboard.Logout.Confirm.Action.logout),
                                      action: logoutAction),
              secondaryButton: .cancel(Text(L10n.Dashboard.Logout.Confirm.Action.cancel)))
    }
}
