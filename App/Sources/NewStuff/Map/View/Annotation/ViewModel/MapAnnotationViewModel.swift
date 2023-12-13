import Foundation

class MapAnnotationViewModel: ObservableObject {
    var name: String {
        annotation.gasStation.name
    }

    var formattedPrice: AttributedString? {
        guard let selectedFuelType = poiManager.fuelType,
              let price = annotation.gasStation.lowestPrice(for: selectedFuelType.keys) else {
            return nil
        }

        let currencySymbol = NSLocale.symbol(for: price.currency)

        guard let formattedPriceValue = priceFormatter.localizedPrice(from: NSNumber(value: price.value), currencySymbol: currencySymbol) else {
            return nil
        }

        return formattedPriceValue
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
    }
}
