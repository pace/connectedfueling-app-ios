import Foundation

public protocol GasStationListRepository {
    func getFuelType(_ completion: @escaping (Result<Domain.FuelType?, Error>) -> Void)

    func setFuelType(_ fuelType: Domain.FuelType, _ completion: @escaping (Result<Bool, Error>) -> Void)

    func fetchGasStations(at location: Domain.Location, _ completion: @escaping (Result<[Domain.GasStation], Error>) -> Void)
}
