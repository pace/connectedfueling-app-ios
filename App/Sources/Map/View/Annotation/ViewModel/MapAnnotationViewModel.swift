import Combine
import Foundation

class MapAnnotationViewModel: ObservableObject {
    @Published var formattedPrice: AttributedString?

    var name: String {
        annotation.gasStation.name
    }

    var showPrices: Bool {
        !ConfigurationManager.configuration.hidePrices
    }

    var usesSmallHeight: Bool {
        formattedPrice == nil && !isClosed
    }

    var isClosed: Bool {
        annotation.gasStation.isClosed
    }

    let annotation: GasStationAnnotation

    private let priceFormatter: PriceNumberFormatter
    private let poiManager: POIManager

    init(annotation: GasStationAnnotation,
         poiManager: POIManager = .init()) {
        self.annotation = annotation
        self.poiManager = poiManager
        self.priceFormatter = PriceNumberFormatter(with: annotation.gasStation.prices.first?.format ?? Constants.GasStation.priceFormatFallback)

        poiManager
            .formattedPricePublisher(gasStation: annotation.gasStation, 
                                     priceFormatter: priceFormatter)
            .assign(to: &$formattedPrice)
    }
}
