import Foundation

public final class UserInteractor {
    private let repository: UserRepository

    public init(repository: UserRepository) {
        self.repository = repository
    }

    public func fetchUserInfo(_ completion: @escaping (Result<UserInfo, Error>) -> Void) {
        return repository.fetchUserInfo(completion)
    }
}
