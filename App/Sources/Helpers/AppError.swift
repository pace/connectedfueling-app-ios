import SwiftUI

struct AppError {
    let title: String
    let description: String?
    let icon: Icon
    let retryAction: RetryAction?

    init(title: String,
         description: String? = nil,
         icon: Icon = .imageResource(.errorIcon),
         retryAction: RetryAction? = nil) {
        self.title = title
        self.description = description
        self.icon = icon
        self.retryAction = retryAction
    }
}

extension AppError {
    enum Icon {
        case imageResource(ImageResource)
        case image(Image)
    }

    struct RetryAction {
        let title: String
        let action: () -> Void
    }
}

// MARK: - Gas station list errors
extension AppError {
    static var locationError: AppError {
        .init(title: L10n.LocationDialog.permissionDeniedTitle,
              description: L10n.LocationDialog.permissionDeniedText,
              retryAction: .init(title: L10n.Alert.LocationPermission.Actions.openSettings,
                                 action: {
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(url)
        }))
    }

    static var emptyError: AppError {
        .init(title: L10n.Dashboard.EmptyView.title,
              description: L10n.Dashboard.EmptyView.description,
              icon: .imageResource(.noGasStationsIcon))
    }
}
