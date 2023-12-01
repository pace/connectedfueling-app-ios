import SwiftUI

struct MenuNavigationView: View {
    var body: some View {
        AppNavigationView {
            MenuView()
                .addNavigationBar(style: .standard(title: L10n.moreTabLabel))
        }
    }
}

#Preview {
    MenuNavigationView()
}
