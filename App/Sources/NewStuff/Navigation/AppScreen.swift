import SwiftUI

enum AppScreen: CaseIterable, Identifiable {
    case gasStationList
    case menu

    var id: AppScreen { self }
}

extension AppScreen {
    @ViewBuilder
    var label: some View {
        switch self {
        case .gasStationList:
            Label("Gas Stations", systemImage: "list.bullet") // TODO: - Localized String

        case .menu:
            Label("Menu", systemImage: "gear") // TODO: - Localized String
        }
    }

    @ViewBuilder
    var destination: some View {
        switch self {
        case .gasStationList:
            GasStationListNavigationView()

        case .menu:
            MenuNavigationView()
        }
    }
}
