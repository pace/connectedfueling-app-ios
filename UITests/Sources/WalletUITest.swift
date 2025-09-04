// Copyright © 2025 PACE Telematics GmbH. All rights reserved.

import XCTest

class WalletUITest: TestBase {
    func testOpenWallet() {
        let app = prepareAppWithoutOnboarding()
        
        app.switchTab(to: .wallet)
        let gasStationListView = app.otherElements[AccessibilityIdentifiers.walletView]
        XCTAssertTrue(gasStationListView.waitForExistence())
    }
}
