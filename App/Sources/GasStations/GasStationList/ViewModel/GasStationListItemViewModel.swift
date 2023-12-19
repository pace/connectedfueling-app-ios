import Foundation

class GasStationListItemViewModel: GasStationItemViewModel {
    @Published var formattedPrice: AttributedString = .init(L10n.listPriceNotAvailable)

    var isHighlighted: Bool {
        gasStation.isNearby && gasStation.isConnectedFuelingEnabled
    }

    var singleLineAddress: String {
        if gasStation.addressLines.count <= 1 {
            return gasStation.addressLines.first ?? ""
        } else {
            var result: String = ""

            if let first = gasStation.addressLines.first,
               !first.isEmpty {
                result.append(first)
            }

            if let second = gasStation.addressLines.last,
               second != result,
               !second.isEmpty {
                result.append(", " + second)
            }

            return result
        }
    }

    var priceAvailable: Bool {
        !gasStation.prices.isEmpty
    }

    var formattedFuelType: String {
        poiManager.fuelType.localizedTitle
    }

    private let poiManager: POIManager

    init(gasStation: GasStation, poiManager: POIManager = .init()) {
        self.poiManager = poiManager

        super.init(gasStation: gasStation)

        poiManager
            .formattedPricePublisher(gasStation: gasStation,
                                     priceFormatter: priceFormatter)
            .map { formattedPrice in
                formattedPrice ?? .init(L10n.listPriceNotAvailable)
            }
            .assign(to: &$formattedPrice)
    }
}
