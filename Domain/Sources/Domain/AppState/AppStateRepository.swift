import Foundation

public protocol AppStateRepository {
    func isOnboardingCompleted(_ completion: @escaping (Result<Bool, Error>) -> Void)

    func setOnboardingCompleted(_ completed: Bool, _ completion: @escaping (Result<Void, Error>) -> Void)
}
