import SwiftUI

struct GasStationListNavigationView: View {
    var body: some View {
        AppNavigationView {
            GasStationListView()
                .addNavigationBar()
        }
    }
}

#Preview {
    GasStationListNavigationView()
}
