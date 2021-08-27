import Foundation

public final class AuthenticationInteractor {
    private let authenticationRepository: AuthenticationRepository

    public init(authenticationRepository: AuthenticationRepository) {
        self.authenticationRepository = authenticationRepository
    }

    public func isAuthenticated(_ completion: @escaping (Result<Bool, Error>) -> Void) {
        authenticationRepository.isAuthenticated(completion)
    }

    public func authenticate(_ completion: @escaping (Result<AccessToken, Error>) -> Void) {
        authenticationRepository.authenticate(completion)
    }

    public func invalidate(_ completion: @escaping (Result<Void, Error>) -> Void) {
        authenticationRepository.invalidateAuthentication(completion)
    }
}
