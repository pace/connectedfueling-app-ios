import Domain
import UserDefaults

class UserDefaultAppStateRepository: AppStateRepository {
    @UserDefault(key: "car.pace.ConnectedFueling.isOnboardingCompleted", defaultValue: false)
    private var isOnboardingCompleted: Bool

    func isOnboardingCompleted(_ completion: @escaping (Result<Bool, Error>) -> Void) {
        completion(.success(isOnboardingCompleted))
    }

    func setOnboardingCompleted(_ completed: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        isOnboardingCompleted = completed

        completion(.success(()))
    }
}
