// Copyright © 2023 PACE Telematics GmbH. All rights reserved.

import SwiftUI

enum AppAlert {
    static var genericError: Alert {
        Alert(title: Text("Oops, something went wrong"),
              message: Text("Please try again"))
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
              message: Text("Please try again"),
              primaryButton: .default(Text("Try again"),
                                      action: retryAction),
              secondaryButton: .cancel())
    }
}
