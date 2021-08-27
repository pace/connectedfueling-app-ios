import Domain
import PACECloudSDK
import UIKit

public enum PACECloudAuthenticationRepositoryError: Error {
    case authenticationFailed
}

struct PACECloudAuthenticationRepository: AuthenticationRepository {
    private var presentingViewController: UIViewController?

    init(presentingViewController: UIViewController?) {
        self.presentingViewController = presentingViewController
        IDKit.presentingViewController = presentingViewController
    }

    func isAuthenticated(_ completion: @escaping (Result<Bool, Error>) -> Void) {
        completion(.success(IDKit.isAuthorizationValid()))
    }

    func authenticate(_ completion: @escaping (Result<AccessToken, Error>) -> Void) {
        IDKit.authorize { result in
            switch result {
            case let .success(accessToken):
                guard let accessToken = accessToken else {
                    return completion(.failure(PACECloudAuthenticationRepositoryError.authenticationFailed))
                }

                completion(.success(AccessToken(rawValue: accessToken)))

            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    func invalidateAuthentication(_ completion: @escaping (Result<Void, Error>) -> Void) {
        IDKit.resetSession {
            completion(.success(()))
        }
    }
}
