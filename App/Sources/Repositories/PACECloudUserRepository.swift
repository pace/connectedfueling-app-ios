import Domain
import PACECloudSDK

struct PACECloudUserRepository: UserRepository {
    func fetchUserInfo(_ completion: @escaping (Result<UserInfo, Error>) -> Void) {
        IDKit.userInfo { result in
            switch result {
            case let .success(userInfo):
                let user = UserInfo(
                    firstName: userInfo.firstName,
                    lastName: userInfo.lastName,
                    email: userInfo.email,
                    isEmailVerified: userInfo.isEmailVerified
                )

                completion(.success(user))

            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
