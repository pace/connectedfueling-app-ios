import MapKit
import PACECloudSDK
import SwiftUI

class GasStationListItemViewModel: ObservableObject {
    @Published var fuelingUrlString: String?

    var isNearby: Bool {
        gasStation.distanceInKilometers ?? 0 < Constants.Distance.formattingThresholdForMetersPrecision - Constants.Distance.roundingThreshold
    }

    var isHighlighted: Bool {
        isNearby && gasStation.isConnectedFuelingEnabled
    }

    var closesIn: Int {
        gasStation.poiOpeningHours.minuteTillClose()
    }

    var isClosed: Bool {
        closesIn == -Int.max
    }

    var showIsClosed: Bool {
        !gasStation.openingHours.isEmpty && isClosed
    }

    var isClosingSoon: Bool {
        closesIn > 0 && closesIn <= 30 // TODO: decide value
    }

    var closingTimeToday: String? {
        let closingHourToday = gasStation.poiOpeningHours.getOpeningHours(for: Date()).toString().components(separatedBy: " – ")

        guard let result = closingHourToday.last,
              !result.isEmpty else { return nil }

        return String(result)
    }

    var distanceStyle: DistanceTagView.Style {
        if showIsClosed || isClosingSoon {
            return .closed(formattedDistance)
        } else if isNearby {
            return .nearby
        } else {
            return .distant(formattedDistance)
        }
    }

    var formattedDistance: String {
        let distance = gasStation.distanceInKilometers ?? 0
        let distanceMeasurement = Measurement<UnitLength>(value: distance, unit: .kilometers)

        if distance < Constants.Distance.formattingThresholdForMetersPrecision - Constants.Distance.roundingThreshold {
            return decimalDistanceFormatter.string(from: distanceMeasurement.converted(to: .meters))
        } else if distance < Constants.Distance.formattingThresholdInKm - Constants.Distance.roundingThreshold {
            return singleFractionDistanceFormatter.string(from: distanceMeasurement)
        } else {
            return decimalDistanceFormatter.string(from: distanceMeasurement)
        }
    }

    var priceAvailable: Bool {
        guard gasStation.fuelPrice != nil,
              gasStation.fuelType != nil else {
            return false
        }

        return true
    }

    var formattedFuelType: String {
        gasStation.fuelType?.localizedTitle.localizedCapitalized ?? L10n.Price.notAvailable
    }

    var formattedPrice: AttributedString {
        guard let price = gasStation.fuelPrice?.value,
              let currency = gasStation.fuelPrice?.currency else {
            return .init(L10n.Price.notAvailable)
        }

        let currencySymbol = NSLocale.symbol(for: currency)

        guard let formattedPriceValue = priceFormatter.localizedPrice(from: NSNumber(value: price), currencySymbol: currencySymbol) else {
            return .init(L10n.Price.notAvailable)
        }

        return formattedPriceValue
    }

    var actionTitle: String {
        gasStation.isConnectedFuelingEnabled ? L10n.commonStartFueling : L10n.commonStartNavigation
    }

    @Published var gasStation: GasStation

    private let priceFormatter: PriceNumberFormatter

    private let decimalDistanceFormatter: MeasurementFormatter = {
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .short
        formatter.unitOptions = .providedUnit
        formatter.numberFormatter.maximumFractionDigits = 0
        formatter.numberFormatter.roundingMode = .halfEven
        return formatter
    }()

    private let singleFractionDistanceFormatter: MeasurementFormatter = {
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .short
        formatter.unitOptions = .providedUnit
        formatter.numberFormatter.maximumFractionDigits = 1
        formatter.numberFormatter.minimumFractionDigits = 1
        return formatter
    }()

    init(gasStation: GasStation) {
        self.gasStation = gasStation
        self.priceFormatter = PriceNumberFormatter(with: gasStation.fuelPrice?.format ?? Constants.GasStationList.priceFormatFallback)
    }

    // TODO: maybe add to sdk?
    private func getClosesAt() -> String? {
        let closingHourToday = gasStation.poiOpeningHours.getOpeningHours(for: Date()).toString().components(separatedBy: " - ")

        guard let result = closingHourToday.last,
              !result.isEmpty else { return nil }

        return String(result)
    }

    func didTapActionButton() {
        if gasStation.isConnectedFuelingEnabled {
            startFueling()
        } else {
            startNavigation()
        }
    }

    func startFueling() {
        fuelingUrlString = PACECloudSDK.URL.fueling(id: gasStation.id).absoluteString
    }

    func startNavigation() {
        guard let location = gasStation.location else {
            NSLog("[GasStationListItemViewModel] Failed starting navigation. No gas station location available.")
            return
        }

        let coordinate: CLLocationCoordinate2D = location.coordinate
        let placemark: MKPlacemark = MKPlacemark(coordinate: coordinate)
        let item = MKMapItem(placemark: placemark)
        item.name = gasStation.name
        item.openInMaps(launchOptions: nil)
    }
}
