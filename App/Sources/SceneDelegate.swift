import JLCoordinator
import UIKit

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    private var initialCoordinator: AppCoordinator?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }

        initialCoordinator = .init(presenter: InitialPresenter(window: .init(windowScene: windowScene)))
        initialCoordinator?.start()
    }
}
