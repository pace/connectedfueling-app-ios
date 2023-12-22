import PACECloudSDK
import SwiftUI
import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        setup()
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        PACECloudSDK.shared.application(open: url)
    }
}

private extension AppDelegate {
    func setup() {
        MigrationManager.migrate()

        setupPACECloudSDK()
        setupCrashReporting()

        setupNavigationBar()
        setupTabBar()

        refreshSessionIfNeeded()
    }

    func setupPACECloudSDK() {
        PACECloudSDK.shared.setup(
            with: .init(
                apiKey: "connected-fueling-app",
                clientId: ConfigurationManager.configuration.clientId,
                environment: Constants.currentEnvironment
            )
        )
    }

    func setupNavigationBar() {
        let navigationBar = UINavigationBar.appearance()
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Color.genericWhite)
        appearance.shadowImage = UIImage()
        appearance.shadowColor = .none
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = navigationBar.standardAppearance
    }

    func setupTabBar() {
        let appearance = UITabBarAppearance()
        appearance.shadowImage = UIImage()
        appearance.backgroundColor = UIColor(Color.genericWhite)
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    func setupCrashReporting() {
        CrashReportingManager.shared.setup()
    }

    func refreshSessionIfNeeded() {
        guard UserDefaults.isOnboardingCompleted else { return }

        Task {
            await UserManager().refresh()
        }
    }
}
