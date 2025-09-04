// Copyright © 2025 PACE Telematics GmbH. All rights reserved.

import XCTest

class ListUITest: TestBase {
    func testOpenList() {
        let app = prepareAppWithoutOnboarding()
        
        app.switchTab(to: .gasStationListView)
        let gasStationListView = app.otherElements[AccessibilityIdentifiers.gasStationListView]
        XCTAssertTrue(gasStationListView.waitForExistence())
    }
}
