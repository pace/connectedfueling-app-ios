import JLCoordinator
import PACECloudSDK
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    private var initialCoordinator: AppCoordinator?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        PACECloudSDK.shared.setup(
            with: .init(
                apiKey: Secrets.apiKey,
                authenticationMode: .native,
                environment: .sandbox,
                customOIDConfiguration: .init(
                    authorizationEndpoint: "\(Secrets.cloudURL)/auth/realms/pace/protocol/openid-connect/auth",
                    tokenEndpoint: "\(Secrets.cloudURL)/auth/realms/pace/protocol/openid-connect/token",
                    userEndpoint: "\(Secrets.cloudURL)/auth/realms/pace/protocol/openid-connect/userinfo",
                    clientId: Secrets.clientID,
                    redirectUri: Secrets.redirectURI
                ),
                isRedirectSchemeCheckEnabled: true,
                domainACL: ["pace.cloud"],
                allowedLowAccuracy: nil,
                speedThresholdInKmPerHour: nil,
                geoAppsScope: "pace-drive-ios"
            )
        )

        applyGlobalTheme()

        if #available(iOS 13.0, *) {
            // NOTE: If iOS 13 is available SceneDelegate will be used to initialize the view
        } else {
            window = UIWindow(frame: UIScreen.main.bounds)

            initialCoordinator = .init(presenter: InitialPresenter(window: window!))
            initialCoordinator?.start()
        }

        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        switch url.host {
        case "redirect":
            AppKit.handleRedirectURL(url)
            return true

        default:
            return false
        }
    }

    private func applyGlobalTheme() {
        let view = UIView.appearance()
        view.tintColor = Asset.Colors.Theme.primary.color

        let navigationBar = UINavigationBar.appearance()
        navigationBar.isTranslucent = false
        navigationBar.barTintColor = Asset.Colors.Theme.primary.color
        navigationBar.tintColor = .white
        navigationBar.setTitleVerticalPositionAdjustment(0, for: .default)
    }
}
