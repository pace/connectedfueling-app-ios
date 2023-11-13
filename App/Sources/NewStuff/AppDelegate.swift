import PACECloudSDK
import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        setupPACECloudSDK()
        setupNavigationBar()
        setupCrashReporting()

        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        PACECloudSDK.shared.application(open: url)
    }
}

private extension AppDelegate {
    func setupPACECloudSDK() {
        PACECloudSDK.shared.setup(
            with: .init(
                apiKey: "connected-fueling-app",
                clientId: "connected-fueling-app-ios",
                environment: sdkEnvironment,
                geoAppsScope: "pace-drive-ios-min"
            )
        )
    }

    func setupNavigationBar() {
        let navigationBar = UINavigationBar.appearance()
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = Asset.Colors.primaryTint.color
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = navigationBar.standardAppearance
        navigationBar.tintColor = Asset.Colors.textLight.color
    }

    func setupCrashReporting() {
        CrashReportingManager().setup()
    }
}
