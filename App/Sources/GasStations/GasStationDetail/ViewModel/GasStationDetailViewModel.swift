import CoreLocation
import Foundation

class GasStationDetailViewModel: GasStationItemViewModel {
    var lastUpdated: String? {
        guard let date = gasStation.lastUpdated else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = .none
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    var location: CLLocationCoordinate2D {
        gasStation.location.coordinate
    }

    var priceInfos: [PriceCardData] {
        gasStation.prices.map {
            let formattedPrice = poiManager.formatPrice(price: $0,
                                                        priceFormatter: priceFormatter)
            return .init(fuelType: $0.fuelType.localizedTitle,
                         price: formattedPrice ?? .init(L10n.Price.notAvailable))
        }
    }

    let style: ConfigurationManager.Configuration.DetailViewStyle

    private(set) var openingHourRows: [OpeningHourInfo] = []
    private let poiManager: POIManager

    init(gasStation: GasStation, 
         poiManager: POIManager = .init(),
         configuration: ConfigurationManager.Configuration = ConfigurationManager.configuration, 
         analyticsManager: AnalyticsManager = .init()) {
        self.poiManager = poiManager
        self.style = configuration.detailViewStyle

        super.init(gasStation: gasStation, analyticsManager: analyticsManager)

        self.openingHourRows = parseGasStationOpeningHours()
    }

    private func parseGasStationOpeningHours() -> [OpeningHourInfo] {
        let openingHoursViewValues: [(String, String)] = gasStation.poiOpeningHours.openingHours().toReadableStrings()
        let openingValues: [OpeningHourInfo] = openingHoursViewValues.map { .init(days: $0.0, hours: $0.1) }
        return openingValues
    }
}
