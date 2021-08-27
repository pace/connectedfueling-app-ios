import Foundation

public protocol GasStationListRepository {
    func getFuelType(_ completion: @escaping (Result<FuelType?, Error>) -> Void)

    func setFuelType(_ fuelType: FuelType, _ completion: @escaping (Result<Bool, Error>) -> Void)

    func fetchGasStations(at location: Location, _ completion: @escaping (Result<[GasStation], Error>) -> Void)
}
