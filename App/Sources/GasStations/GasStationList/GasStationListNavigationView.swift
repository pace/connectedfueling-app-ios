import SwiftUI

struct GasStationListNavigationView: View {
    var body: some View {
        AppNavigationView {
            Text("Gas Station List")
                .addNavigationBar()
        }
    }
}

#Preview {
    GasStationListNavigationView()
}
