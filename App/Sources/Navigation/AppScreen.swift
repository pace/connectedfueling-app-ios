import SwiftUI

enum AppScreen: CaseIterable, Identifiable {
    case map
    case gasStationList
    case wallet
    case menu

    var id: AppScreen { self }
}

extension AppScreen {
    @ViewBuilder
    var label: some View {
        Label {
            Text(title)
        } icon: {
            image
        }
    }

    @ViewBuilder
    var destination: some View {
        switch self {
        case .map:
            MapNavigationView()

        case .gasStationList:
            GasStationListNavigationView()

        case .wallet:
            WalletNavigationView()

        case .menu:
            MenuNavigationView()
        }
    }

    private var image: Image {
        switch self {
        case .map:
            Image.mapTabIcon.renderingMode(.template)

        case .gasStationList:
            Image.listTabIcon.renderingMode(.template)

        case .wallet:
            Image.walletTabIcon.renderingMode(.template)

        case .menu:
            Image.menuTabIcon.renderingMode(.template)
        }
    }

    private var title: String {
        switch self {
        case .map:
            L10n.mapTabLabel

        case .gasStationList:
            L10n.listTabLabel

        case .wallet:
            L10n.walletTabLabel

        case .menu:
            L10n.moreTabLabel
        }
    }
}