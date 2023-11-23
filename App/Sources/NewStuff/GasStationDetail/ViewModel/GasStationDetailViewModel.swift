// Copyright © 2023 PACE Telematics GmbH. All rights reserved.

import CoreLocation
import Foundation
import MapKit
import PACECloudSDK
import SwiftUI
import Combine

class GasStationDetailViewModel: ObservableObject {
    @Published var fuelingUrlString: String?

    @Published var gasStation: GasStation

    var anyCancellable: AnyCancellable? = nil

    private let priceFormatter: PriceNumberFormatter

    var isNearby: Bool {
        gasStation.distanceInKilometers ?? 0 < Constants.Distance.formattingThresholdForMetersPrecision - Constants.Distance.roundingThreshold
    }

    var closesIn: Int {
        gasStation.poiOpeningHours.minuteTillClose()
    }

    var isClosed: Bool {
        closesIn == -Int.max
    }

    var lastUpdated: String? {
        guard let date = gasStation.lastUpdated else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = .none
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    var distanceStyle: DistanceTagView.Style {
        if isClosed {
            return .closed(formattedDistance)
        } else if isNearby {
            return .nearby
        } else {
            return .distant(formattedDistance)
        }
    }

    var location: CLLocationCoordinate2D {
        gasStation.location?.coordinate ?? .init()
    }

    var openingHourRows: [OpeningHourInfo] = []

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

    var formattedPrice: AttributedString {
        formattedPrice(for: gasStation.fuelPrice?.value, currency: gasStation.fuelPrice?.currency)
    }

    private func formattedPrice(for price: Double?, currency: String?) -> AttributedString {
        guard let price = price,
              let currency = currency else {
            return .init(L10n.Price.notAvailable)
        }

        let currencySymbol = NSLocale.symbol(for: currency)

        guard let formattedPriceValue = priceFormatter.localizedPrice(from: NSNumber(value: price), currencySymbol: currencySymbol) else {
            return .init(L10n.Price.notAvailable)
        }

        return formattedPriceValue
    }

    var priceInfos: [PriceCardData] {
        gasStation.prices.map { .init(fuelType: $0.fuelType.localizedTitle ?? "unknown", price: formattedPrice(for: $0.fuelPrice.value, currency: $0.fuelPrice.currency)) }
    }

    var actionTitle: String {
        gasStation.isConnectedFuelingEnabled ? L10n.Dashboard.Actions.startFueling : L10n.Dashboard.Actions.navigate
    }

    init(gasStation: GasStation) {
        self.gasStation = gasStation
        self.priceFormatter = PriceNumberFormatter(with: gasStation.fuelPrice?.format ?? Constants.GasStationList.priceFormatFallback)
        let openingHoursViewValues: [(String, String)] = gasStation.poiOpeningHours.openingHours().toReadableStrings()
        self.openingHourRows = parseGasStationOpeningHours(with: openingHoursViewValues, from: gasStation)

        // TODO: How to handle nested ObservableObjects (here work around)
        anyCancellable = gasStation.objectWillChange.sink { [weak self] _ in
            self?.objectWillChange.send()
        }
    }

    private func parseGasStationOpeningHours(with openingHoursViewValues: [(String, String)],
                                             from station: GasStation) -> [OpeningHourInfo] {

        let openingValues: [OpeningHourInfo] = openingHoursViewValues.map { .init(days: $0.0, hours: $0.1) }

        return openingValues
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
            NSLog("[GasStationDetailViewModel] Failed starting navigation. No gas station location available.")
            return
        }

        let coordinate: CLLocationCoordinate2D = location.coordinate
        let placemark: MKPlacemark = MKPlacemark(coordinate: coordinate)
        let item = MKMapItem(placemark: placemark)
        item.name = gasStation.name
        item.openInMaps(launchOptions: nil)
    }
}
