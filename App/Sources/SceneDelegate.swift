import JLCoordinator
import PACECloudSDK
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

    func scene(_ scene: UIScene,
               openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
            return
        }
        let _ = UIApplication.shared.delegate?.application?(UIApplication.shared, open: url)
    }
}
