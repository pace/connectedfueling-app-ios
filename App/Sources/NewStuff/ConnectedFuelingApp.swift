import PACECloudSDK
import SwiftUI

@main
struct ConnectedFuelingApp: App {
    init() {
        setupPACECloudSDK()
        setupNavigationBar()
    }

    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
                    .addNavigationBar()
            }
            .accentColor(Color.textLight)
        }
    }

    private func setupPACECloudSDK() {
        PACECloudSDK.shared.setup(
            with: .init(
                apiKey: "connected-fueling-app",
                clientId: "connected-fueling-app-ios",
                environment: sdkEnvironment,
                geoAppsScope: "pace-drive-ios-min"
            )
        )
    }

    private func setupNavigationBar() {
        let navigationBar = UINavigationBar.appearance()
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = Asset.Colors.primaryTint.color
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = navigationBar.standardAppearance
        navigationBar.tintColor = Asset.Colors.textLight.color
    }
}
