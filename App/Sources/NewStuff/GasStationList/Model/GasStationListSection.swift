import SwiftUI

enum GasStationListSection: Hashable {
    case nearest(GasStation)
    case other([GasStation])

    @ViewBuilder
    var header: some View {
        let title = if case .nearest = self {
            L10n.Dashboard.Sections.nearestGasStation
        } else {
            L10n.Dashboard.Sections.otherGasStations
        }

        TextLabel(title)
            .font(.system(size: 20, weight: .semibold))
    }

    var gasStations: [GasStation] {
        switch self {
        case .nearest(let gasStation):
            return [gasStation]

        case .other(let gasStations):
            return gasStations
        }
    }

    func hash(into hasher: inout Hasher) {
        switch self {
        case .nearest(let station):
            hasher.combine(station.id)

        case .other(let stations):
            hasher.combine(stations.map { $0.id })
        }
    }
}
