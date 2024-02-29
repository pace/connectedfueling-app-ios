import SwiftUI

struct MapNavigationView: View {
    @StateObject var viewModel: MapNavigationViewModel = .init()
    @StateObject var analyticsManager: AnalyticsManager

    init(analyticsManager: AnalyticsManager = .init()) {
        self._analyticsManager = .init(wrappedValue: analyticsManager)
    }

    var body: some View {
        AppNavigationView {
            MapView(analyticsManager: analyticsManager) { alert in
                viewModel.showAlert(alert)
            }
        }
        .alert(item: $viewModel.alert) { alert in
            alert
        }
    }
}
