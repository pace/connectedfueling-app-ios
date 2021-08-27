import Foundation

public protocol AuthenticationRepository {
    func isAuthenticated(_ completion: @escaping (Result<Bool, Error>) -> Void)

    func authenticate(_ completion: @escaping (Result<AccessToken, Error>) -> Void)

    func invalidateAuthentication(_ completion: @escaping (Result<Void, Error>) -> Void)
}
