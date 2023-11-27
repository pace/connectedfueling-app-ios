import SwiftUI

struct GasStationListNavigationView: View {
    var body: some View {
        AppNavigationView {
            switch ConfigurationManager.configuration.gasStationListStyle {
            case .primary:
                GasStationListView()

            case .secondary:
                GasStationListView()
                    .addNavigationBar(style: .centeredIcon(icon: .secondaryHeaderIcon))
            }
        }
    }
}

#Preview {
    GasStationListNavigationView()
}
