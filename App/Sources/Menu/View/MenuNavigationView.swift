import SwiftUI

struct MenuNavigationView: View {
    private let analyticsManager: AnalyticsManager

    init(analyticsManager: AnalyticsManager) {
        self.analyticsManager = analyticsManager
    }

    var body: some View {
        AppNavigationView {
            MenuView(analyticsManager: analyticsManager)
                .addNavigationBar(style: .standard(title: L10n.moreTabLabel))
        }
    }
}

#Preview {
    MenuNavigationView(analyticsManager: .init())
}
