import XCTest

class OnboardingUITest: XCTestCase {
    
    func testOnboarding() {
        let springboardApp = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        let alertButtons = springboardApp.alerts.buttons
        let app = XCUIApplication()
        app.launchArguments = [LaunchArguments.launchOnboarding]
        app.launch()
        // Legal
        app.buttons[AccessibilityIdentifiers.commonUseAccept].tap()
        
        // Analyse
        app.buttons[AccessibilityIdentifiers.commonUseAccept].tap()
        
        
        // Push notification dialog
        if app.staticTexts[AccessibilityIdentifiers.onboardingNotificationPermissionTitle].exists {
            app.buttons[AccessibilityIdentifiers.commonUseNext].tap()
            if alertButtons.element(boundBy: 1).exists {
                alertButtons.element(boundBy: 1).tap()
            }
        }
        // Location dialog
        if app.staticTexts[AccessibilityIdentifiers.onboardingLocationPermissionTitle].exists {
            app.buttons[AccessibilityIdentifiers.commonUseNext].tap()
            if alertButtons.element(boundBy: 1).exists {
                alertButtons.element(boundBy: 1).tap()
            }
        }
        
        // Profile Login
        app.buttons[AccessibilityIdentifiers.onboardingAuthenticationAction].tap()
    }
}
