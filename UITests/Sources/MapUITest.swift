import XCTest

class MapUITest: TestBase {
    func testOpenMap() {
        let app = prepareAppWithoutOnboarding()
        
        app.switchTab(to: .map)
        let gasStationListView = app.otherElements[AccessibilityIdentifiers.mapView]
        XCTAssertTrue(gasStationListView.waitForExistence())
    }
}
