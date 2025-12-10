import SwiftUI

struct GasStationListNavigationView: View {
    let analyticsManager: AnalyticsManager
    let gasStationListViewModel: GasStationListViewModel

    init(analyticsManager: AnalyticsManager = .init()) {
        self.analyticsManager = analyticsManager
        self.gasStationListViewModel = .init(analyticsManager: analyticsManager)
    }

    var body: some View {
        AppNavigationView {
            switch ConfigurationManager.configuration.gasStationListStyle {
            case .primary:
                GasStationListView(viewModel: gasStationListViewModel, analyticsManager: analyticsManager)
                    .onAppear {
                        gasStationListViewModel.viewWillAppear()
                    }

            case .secondary:
                GasStationListView(viewModel: gasStationListViewModel, analyticsManager: analyticsManager)
                    .addNavigationBar(style: .centeredIcon(icon: .secondaryHeaderIcon), backgroundColor: .primaryTint)
                    .onAppear {
                        gasStationListViewModel.viewWillAppear()
                    }
            }
        }
    }
}

#Preview {
    GasStationListNavigationView()
}
