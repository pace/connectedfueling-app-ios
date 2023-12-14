import CoreLocation
import Foundation
import PACECloudSDK

struct POIManager {
    var fuelType: FuelType? {
        get {
            guard let data = UserDefaults.standard.data(forKey: Constants.UserDefaults.fuelType),
                  let fuelType = try? JSONDecoder().decode(FuelType.self, from: data)
            else { return nil }

            return fuelType
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else { return }
            UserDefaults.standard.set(data, forKey: Constants.UserDefaults.fuelType)
        }
    }

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

    // TODO: fetch single gas station

//    func fetchCofuStation(with id: String) async -> Result<GasStation, Error> {
//        let selectedFuelType = fuelType
//
//        switch result {
//        case let .success(poiStations):
//            let gasStations = await withTaskGroup(of: GasStation?.self, returning: [GasStation].self) { group in
//                for poiStation in poiStations where poiStation.isConnectedFuelingAvailable {
//                    guard let poiStationId = poiStation.id else { continue }
//
//                    group.addTask {
//                        let isPoiInRange = await POIKit.isPoiInRange(id: poiStationId)
//                        let gasStation = self.makeGasStation(for: poiStation,
//                                                             selectedFuelType: selectedFuelType,
//                                                             location: location,
//                                                             isConnectedFuelingEnabled: isPoiInRange)
//                        return gasStation
//                    }
//                }
//
//                let gasStations: [GasStation] = await group.reduce(into: []) {
//                    guard let gasStation = $1 else { return }
//                    $0.append(gasStation)
//                }
//
//                return gasStations
//            }
//
//            return .success(gasStations)
//
//        case .failure(let error):
//            return .failure(error)
//        }
//    }
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
