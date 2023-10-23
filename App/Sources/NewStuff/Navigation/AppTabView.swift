import SwiftUI

struct AppTabView: View {
    @Binding private var selection: AppScreen

    init(selection: Binding<AppScreen>) {
        self._selection = selection
    }

    var body: some View {
        TabView(selection: $selection) {
            ForEach(AppScreen.allCases) { screen in
                screen.destination
                    .tag(screen)
                    .tabItem { screen.label }
            }
        }
        .accentColor(.primaryTint)
    }
}
