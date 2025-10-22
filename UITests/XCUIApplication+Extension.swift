import XCTest

extension XCUIApplication {
    func switchTab(to tab: Tab) {
        tabBars.buttons[tab.identifier].tap()
    }
    
    enum Tab: String {
        case map
        case gasStationListView
        case wallet
        case menu

        var identifier: String {
            switch self {
            case .map:
                return AccessibilityIdentifiers.mapTabBarItem

            case .gasStationListView:
                return AccessibilityIdentifiers.gasStationListTabBarItem

            case .wallet:
                return AccessibilityIdentifiers.walletTabBarItem

            case .menu:
                return AccessibilityIdentifiers.menuTabBarItem
            }
        }
    }
}
