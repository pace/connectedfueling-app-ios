import SwiftUI

struct GasStationListNavigationView: View {
    let analyticsManager: AnalyticsManager

    init(analyticsManager: AnalyticsManager = .init()) {
        self.analyticsManager = analyticsManager
    }

    var body: some View {
        AppNavigationView {
            switch ConfigurationManager.configuration.gasStationListStyle {
            case .primary:
                GasStationListView(viewModel: .init(analyticsManager: analyticsManager), analyticsManager: analyticsManager)

            case .secondary:
                GasStationListView(viewModel: .init(analyticsManager: analyticsManager), analyticsManager: analyticsManager)
                    .addNavigationBar(style: .centeredIcon(icon: .secondaryHeaderIcon), backgroundColor: .primaryTint)
            }
        }
    }
}

#Preview {
    GasStationListNavigationView()
}
