import CoreLocation
import Domain
import Foundation
import PACECloudSDK
import UserDefaults

enum PACECloudGasStationListError: Error {
    case unknownError
}

final class PACECloudGasStationListRepository: GasStationListRepository {
    @UserDefault(key: "car.pace.ConnectedFueling.fuelType", defaultValue: nil)
    private var fuelType: Domain.FuelType?

    private let poiKitManager: POIKit.POIKitManager

    init(poiKitManager: POIKit.POIKitManager) {
        self.poiKitManager = poiKitManager
    }

    func getFuelType(_ completion: @escaping (Result<Domain.FuelType?, Error>) -> Void) {
        completion(.success(fuelType))
    }

    func setFuelType(_ fuelType: Domain.FuelType, _ completion: @escaping (Result<Bool, Error>) -> Void) {
        self.fuelType = fuelType
        completion(.success(true))
    }

    func fetchGasStations(at location: Location, _ completion: @escaping (Result<[GasStation], Error>) -> Void) {
        let center = CLLocation(
            latitude: CLLocationDegrees(location.latitude),
            longitude: CLLocationDegrees(location.longitude)
        )

        POIKit.requestCofuGasStations(center: center, radius: 10_000) { result in
            switch result {
            case let .success(stations):
                var response: [GasStation] = []
                let dispatchGroup = DispatchGroup()
                stations
                    .filter { $0.isConnectedFuelingAvailable }
                    .forEach { station in
                        if let identifier = station.id {
                            dispatchGroup.enter()

                            POIKit.isPoiInRange(id: identifier, at: center) { [weak self] isFuelingAvailable in
                                guard let self = self else { return }

                                response.append(self.makeGasStation(for: station, center: center, isFuelingEnabled: isFuelingAvailable))
                                dispatchGroup.leave()
                            }
                        } else {
                            response.append(self.makeGasStation(for: station, center: center, isFuelingEnabled: false))
                        }
                    }

                dispatchGroup.notify(queue: .main) {
                    completion(.success(response))
                }

            case let .failure(error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}

// MARK: - Model Mapping
extension PACECloudGasStationListRepository {
    private func makeGasStation(for station: POIKit.GasStation, center: CLLocation, isFuelingEnabled: Bool) -> GasStation {
        let distance = station.coordinate.flatMap {
            Float(center.distance(from: CLLocation(latitude: $0.latitude, longitude: $0.longitude))) / 1_000
        }

        let fuelPrice = station.prices.first { price in
            return price.fuelType == fuelType?.rawValue
        }

        return .init(
            identifier: station.id,
            name: station.stationName ?? "",
            addressLines: station.address.flatMap(Self.makeAddressLines(for:)) ?? [],
            distanceInKilometers: distance,
            location: station.coordinate.flatMap { Location(longitude: $0.longitude, latitude: $0.latitude) },
            paymentMethods: station.cofuPaymentMethods,
            isFuelingAvailable: station.isConnectedFuelingAvailable,
            isFuelingEnabled: isFuelingEnabled,
            fuelType: fuelType,
            fuelPrice: fuelPrice.flatMap(makeFuelPrice),
            currency: station.currency
        )
    }

    private func makeFuelPrice(for price: PCPOIFuelPrice) -> FuelPrice? {
        guard let value = price.price else { return nil }

        return .init(value: value, currency: price.currency)
    }

    private static func makeAddressLines(for address: PCPOIGasStation.Address) -> [String] {
        let street = [address.street, address.houseNo].compactMap { $0 }.joined(separator: " ")
        let city = [address.postalCode, address.city].compactMap { $0 }.joined(separator: " ")
        return [street, city]
    }
}
