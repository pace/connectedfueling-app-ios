import Combine
import Foundation

class MapAnnotationViewModel: ObservableObject {
    @Published var formattedPrice: AttributedString?

    var name: String {
        gasStation.name
    }

    var showPrices: Bool {
        !ConfigurationManager.configuration.hidePrices
    }

    var usesSmallHeight: Bool {
        formattedPrice == nil && !isClosed
    }

    var isClosed: Bool {
        gasStation.isClosed
    }

    let gasStation: GasStation

    private let priceFormatter: PriceNumberFormatter
    private let poiManager: POIManager

    init(gasStation: GasStation,
         poiManager: POIManager = .init()) {
        self.gasStation = gasStation
        self.poiManager = poiManager
        self.priceFormatter = PriceNumberFormatter(with: gasStation.prices.first?.format ?? Constants.GasStation.priceFormatFallback)

        gasStation
            .$currentPrice
            .map { [weak self] currentPrice in
                guard let self = self,
                      let currentPrice = currentPrice else { return nil }
                
                return self.formatPrice(price: currentPrice, priceFormatter: self.priceFormatter)
            }
            .eraseToAnyPublisher()
            .assign(to: &$formattedPrice)
    }

    private func formatPrice(price: FuelPrice,
                             priceFormatter: PriceNumberFormatter) -> AttributedString? {
        let currencySymbol = NSLocale.symbol(for: price.currency)

        guard let formattedPriceValue = priceFormatter.localizedPrice(from: NSNumber(value: price.value),
                                                                      currencySymbol: currencySymbol) else {
            return nil
        }

        return formattedPriceValue
    }
}
