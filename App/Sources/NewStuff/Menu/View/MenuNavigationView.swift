import SwiftUI

struct MenuNavigationView: View {
    var body: some View {
        AppNavigationView {
            MenuView()
                .addNavigationBar(showsLogo: false, navigationTitle: L10n.moreTabLabel)
        }
    }
}

#Preview {
    MenuNavigationView()
}
