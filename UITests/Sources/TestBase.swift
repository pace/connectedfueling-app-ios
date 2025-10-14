import XCTest

class TestBase: XCTestCase {
    func prepareAppWithoutOnboarding() -> XCUIApplication {
        let springboardApp = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        let alertButtons = springboardApp.alerts.buttons
        let app = XCUIApplication()
        app.launchArguments = [LaunchArguments.skipOnboarding]
        app.launch()
        
        //Location dialog
        if alertButtons.element(boundBy: 1).exists {
            alertButtons.element(boundBy: 1).tap()
        }
        
        if app.staticTexts[AccessibilityIdentifiers.legalUpdateTrackingTitle].exists {
            app.buttons[AccessibilityIdentifiers.commonUseAccept].tap()
        }
        
        // Push notification dialog
        if app.staticTexts[AccessibilityIdentifiers.notificationPermissionRequestTitle].exists {
            app.buttons[AccessibilityIdentifiers.commonUseNext].tap()
            if alertButtons.element(boundBy: 1).exists {
                alertButtons.element(boundBy: 1).tap()
            }
        }
        return app
    }
}
