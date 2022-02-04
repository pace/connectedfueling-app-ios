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
                apiKey: "connected-fueling-app",
                authenticationMode: .native,
                environment: sdkEnvironment,
                customOIDConfiguration: nil,
                isRedirectSchemeCheckEnabled: true,
                domainACL: ["pace.cloud"],
                allowedLowAccuracy: nil,
                speedThresholdInKmPerHour: nil,
                geoAppsScope: "pace-drive-ios-min"
            )
        )

        applyGlobalTheme()
        AppKit.delegate = self

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
        return PACECloudSDK.shared.application(open: url)
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

extension AppDelegate: AppKitDelegate {
    func didFail(with error: AppKit.AppError) {}
    func didReceiveAppDrawers(_ appDrawers: [AppKit.AppDrawer], _ appDatas: [AppKit.AppData]) {}
}
