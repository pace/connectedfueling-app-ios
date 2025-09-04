// Copyright © 2025 PACE Telematics GmbH. All rights reserved.

import XCTest

extension XCUIElement {
    func waitForExistence(_ timeout: TimeInterval = 10) -> Bool {
        self.waitForExistence(timeout: timeout)
    }
}
