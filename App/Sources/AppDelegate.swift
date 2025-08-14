import PACECloudSDK
import SwiftUI
import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {
    let analyticsManager = AnalyticsManager()

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
        #if SANDBOX
        setupLauchParameters()
        #endif
        MigrationManager.migrate()

        setupPACECloudSDK()
        setupCrashReporting()
        setupAnalytics()

        setupNavigationBar()
        setupTabBar()

        setupSession()
    }
    
    #if SANDBOX
    func setupLauchParameters() {
        if CommandLine.arguments.contains(LaunchArguments.skipOnboarding) {
            UserDefaults.isOnboardingCompleted = true
        } else if CommandLine.arguments.contains(LaunchArguments.launchOnboarding) {
            UserDefaults.isOnboardingCompleted = false
        }
    }
    #endif

    func setupPACECloudSDK() {
        
        
        PACECloudSDK.shared.setup(
            with: .init(
                apiKey: "connected-fueling-app",
                clientId: ConfigurationManager.configuration.clientId,
                environment: Constants.currentEnvironment,
                customOIDConfiguration: getOIDConfiguration(),
                logLevel: .debug,
                persistLogs: false
            )
        )
    }
    
    func getOIDConfiguration() -> IDKit.OIDConfiguration? {
        var exchangeConfig: IDKit.TokenExchangeConfiguration?
        if let tokenExchange = ConfigurationManager.configuration.tokenExchange {
            exchangeConfig = IDKit.TokenExchangeConfiguration(exchangeClientID: tokenExchange.clientId,
                                                              exchangeIssuerID: tokenExchange.issuerId,
                                                              exchangeClientSecret: tokenExchange.clientSecret)
        }
        
        var oidConfig: IDKit.OIDConfiguration?
        if let externalOIDC = ConfigurationManager.configuration.externalOIDC {
            oidConfig = IDKit.OIDConfiguration(authorizationEndpoint: externalOIDC.authEndpoint,
                                               tokenEndpoint: externalOIDC.tokenEndpoint,
                                               endSessionEndpoint: externalOIDC.endSessionEndpoint,
                                               clientId: ConfigurationManager.configuration.clientId,
                                               clientSecret: externalOIDC.clientSecret,
                                               redirectUri: externalOIDC.redirectUri,
                                               tokenExchangeConfig: exchangeConfig)
        }
        return oidConfig
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

    func setupAnalytics() {
        analyticsManager.setup()
    }

    func setupSession() {
        guard UserDefaults.isOnboardingCompleted else { return }

        Task {
            await UserManager().refresh()

            let paymentManager = PaymentManager()
            _ = await paymentManager.is2FANeededForPayments()
            _ = await paymentManager.isNativePaymentMethodOnboardingEnabled()
        }
    }
}
