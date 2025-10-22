import XCTest

class MenuUITest: TestBase {
    func testOpenMenu() {
        let app = prepareAppWithoutOnboarding()
        
        app.switchTab(to: .menu)
        let menuView = app.otherElements[AccessibilityIdentifiers.menuView]
        XCTAssertTrue(menuView.waitForExistence())
    }
}
