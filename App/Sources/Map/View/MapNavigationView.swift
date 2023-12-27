import SwiftUI

struct MapNavigationView: View {

    let analyticsManager: AnalyticsManager

    init(analyticsManager: AnalyticsManager = .init()) {
        self.analyticsManager = analyticsManager
    }

    var body: some View {
        AppNavigationView {
            MapView(analyticsManager: analyticsManager)
        }
    }
}
