import XCTest

class ListUITest: TestBase {
    func testOpenList() {
        let app = prepareAppWithoutOnboarding()
        
        app.switchTab(to: .gasStationListView)
        let gasStationListView = app.otherElements[AccessibilityIdentifiers.gasStationListView]
        XCTAssertTrue(gasStationListView.waitForExistence())
    }
}
