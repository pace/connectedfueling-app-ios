import Foundation

public protocol UserRepository {
    func fetchUserInfo(_ completion: @escaping (Result<UserInfo, Error>) -> Void)
}
