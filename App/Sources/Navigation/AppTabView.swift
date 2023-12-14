import SwiftUI

struct AppTabView: View {
    @Binding private var selection: AppScreen

    init(selection: Binding<AppScreen>) {
        self._selection = selection
    }

    var body: some View {
        TabView(selection: $selection) {
            ForEach(appScreens) { screen in
                screen.destination
                    .tag(screen)
                    .tabItem {
                        screen.label
                    }
            }
        }
        .accentColor(.primaryTint)
    }

    var appScreens: [AppScreen] {
        if !ConfigurationManager.configuration.isMapEnabled {
            AppScreen.allCases.filter { $0 != .map }
        } else {
            AppScreen.allCases
        }
    }
}
