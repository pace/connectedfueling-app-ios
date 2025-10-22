import XCTest

extension XCUIElement {
    func waitForExistence(_ timeout: TimeInterval = 10) -> Bool {
        self.waitForExistence(timeout: timeout)
    }
}
