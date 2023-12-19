import Combine
import CoreLocation
import Foundation
import PACECloudSDK

struct POIManager {
    func fetchCofuStations(at location: CLLocation) async -> Result<[GasStation], Error> {
        let result = await POIKit.requestCofuGasStations(center: location, radius: Constants.GasStation.cofuStationRadius)
        let selectedFuelType = fuelType

        switch result {
        case let .success(poiStations):
            let gasStations = await withTaskGroup(of: GasStation?.self, returning: [GasStation].self) { group in
                for poiStation in poiStations where poiStation.isConnectedFuelingAvailable {
                    guard let poiStationId = poiStation.id else { continue }

                    group.addTask {
                        let isPoiInRange = await POIKit.isPoiInRange(id: poiStationId)
                        let gasStation = self.makeGasStation(for: poiStation,
                                                             selectedFuelType: selectedFuelType,
                                                             location: location,
                                                             isConnectedFuelingEnabled: isPoiInRange)
                        return gasStation
                    }
                }

                let gasStations: [GasStation] = await group.reduce(into: []) {
                    guard let gasStation = $1 else { return }
                    $0.append(gasStation)
                }

                return gasStations
            }

            return .success(gasStations)

        case .failure(let error):
            return .failure(error)
        }
    }
}

// MARK: - Fuel type
extension POIManager {
    var fuelType: FuelType {
        get {
            UserDefaults.fuelType
        }
        set {
            UserDefaults.fuelType = newValue
        }
    }

    var selectedFuelTypePublisher: AnyPublisher<FuelType, Never> {
        UserDefaults.standard
            .publisher(for: \.fuelTypeRawValue)
            .removeDuplicates()
            .compactMap { FuelType(rawValue: $0) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func formattedPricePublisher(gasStation: GasStation,
                                 priceFormatter: PriceNumberFormatter) -> AnyPublisher<AttributedString?, Never> {
        selectedFuelTypePublisher
            .map { selectedFuelType in
                formatPrice(gasStation: gasStation, 
                            selectedFuelType: selectedFuelType,
                            priceFormatter: priceFormatter)
            }
            .eraseToAnyPublisher()
    }

    private func formatPrice(gasStation: GasStation, 
                             selectedFuelType: FuelType,
                             priceFormatter: PriceNumberFormatter) -> AttributedString? {
        guard let price = gasStation.lowestPrice(for: selectedFuelType.keys) else { return nil }

        let currencySymbol = NSLocale.symbol(for: price.currency)

        guard let formattedPriceValue = priceFormatter.localizedPrice(from: NSNumber(value: price.value),
                                                                      currencySymbol: currencySymbol) else { return nil }

        return formattedPriceValue
    }
}

private extension POIManager {
    func makeGasStation(for station: POIKit.GasStation, selectedFuelType: FuelType?, location: CLLocation, isConnectedFuelingEnabled: Bool) -> GasStation? {
        guard let stationId = station.id,
              let coordinate = station.coordinate else { return nil }

        let stationLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let distanceInKilometers = location.distance(from: stationLocation) / 1_000

        let priceFormat = station.priceFormat ?? Constants.GasStation.priceFormatFallback
        let currency = station.currency
        let prices: [FuelPrice] = station.prices.compactMap {
            makeFuelPrice(for: $0, currency: currency, priceFormat: priceFormat)
        }
        let openingHours = station.openingHours?.rules?.map { OpeningHours(from: $0) } ?? []

        return .init(id: stationId,
                     name: station.stationName ?? L10n.gasStationDefaultName,
                     addressLines: station.address.flatMap(makeAddressLines) ?? [],
                     distanceInKilometers: distanceInKilometers,
                     location: stationLocation,
                     paymentMethods: station.cofuPaymentMethods,
                     isConnectedFuelingEnabled: isConnectedFuelingEnabled,
                     prices: prices,
                     lastUpdated: station.lastUpdated,
                     openingHours: openingHours)
    }

    func makeFuelPrice(for price: PCPOIFuelPrice, currency: String?, priceFormat: String) -> FuelPrice? {
        guard let value = price.price,
              let rawFuelType = price.fuelType,
              let fuelType: FuelType = .init(rawValue: rawFuelType),
              let currency else { return nil }

        return .init(value: value, fuelType: fuelType, currency: currency, format: priceFormat)
    }

    func makeAddressLines(for address: PCPOIGasStation.Address) -> [String] {
        let street = [address.street, address.houseNo].compactMap { $0 }.joined(separator: " ")
        let city = [address.postalCode, address.city].compactMap { $0 }.joined(separator: " ")
        return [street, city]
    }
}
