import SwiftUI

struct AppTabView: View {
    @Binding private var selection: AppScreen

    let analyticsManager: AnalyticsManager

    init(selection: Binding<AppScreen>, analyticsManager: AnalyticsManager = .init()) {
        self._selection = selection
        self.analyticsManager = analyticsManager
    }

    var body: some View {
        TabView(selection: $selection) {
            ForEach(appScreens) { screen in
                screen.destination(analyticsManager: analyticsManager)
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
