import Foundation

public final class AppStateInteractor {
    private let appStateRepository: AppStateRepository

    public init(appStateRepository: AppStateRepository) {
        self.appStateRepository = appStateRepository
    }

    public func isOnboardingCompleted(_ completion: @escaping (Result<Bool, Error>) -> Void) {
        appStateRepository.isOnboardingCompleted(completion)
    }

    public func setOnboardingCompleted(_ completed: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        appStateRepository.setOnboardingCompleted(completed, completion)
    }
}
