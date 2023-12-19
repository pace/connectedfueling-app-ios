import Foundation
import MapKit
import PACECloudSDK

class GasStationItemViewModel: ObservableObject {
    @Published var fuelingUrlString: String?
    @Published var gasStation: GasStation

    var showPrices: Bool {
        !ConfigurationManager.configuration.hidePrices
    }

    var isClosed: Bool {
        gasStation.isClosed
    }

    var isClosingSoon: Bool {
        gasStation.closesIn > 0 && gasStation.closesIn <= 30 // TODO: decide value
    }

    var closingTimeToday: String? {
        let closingHourToday = gasStation.poiOpeningHours.getOpeningHours(for: Date()).toString().components(separatedBy: " – ")

        guard let result = closingHourToday.last,
              !result.isEmpty else { return nil }

        return String(result)
    }

    var distanceStyle: DistanceTagView.Style {
        if isClosed || isClosingSoon {
            return .closed(formattedDistance)
        } else if gasStation.isNearby {
            return .nearby
        } else {
            return .distant(formattedDistance)
        }
    }

    var actionTitle: String {
        gasStation.isConnectedFuelingEnabled ? L10n.commonStartFueling : L10n.commonStartNavigation
    }

    private var formattedDistance: String {
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

    let priceFormatter: PriceNumberFormatter

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
        self.priceFormatter = PriceNumberFormatter(with: gasStation.prices.first?.format ?? Constants.GasStation.priceFormatFallback)
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
        let coordinate: CLLocationCoordinate2D = gasStation.location.coordinate
        let placemark: MKPlacemark = MKPlacemark(coordinate: coordinate)
        let item = MKMapItem(placemark: placemark)
        item.name = gasStation.name
        item.openInMaps(launchOptions: nil)
    }
}
