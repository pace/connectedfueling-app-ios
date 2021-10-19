import Domain
import JLCoordinator
import PACECloudSDK
import UIKit

final class PaymentHistoryCoordinator: Coordinator, AppKitDelegate {
    typealias Callback = () -> Void

    private let callback: Callback?
    private var appKitDelegate: AppKitDelegate? // swiftlint:disable:this weak_delegate
    private lazy var viewController: AppViewController = AppKit.appViewController(
        presetUrl: .transactions,
        isModalInPresentation: false,
        completion: callback
    )

    init(presenter: Presenter, callback: Callback? = nil) {
        self.callback = callback

        super.init(presenter: presenter)
    }

    override func start() {
        presenter.present(viewController, animated: true)
        appKitDelegate = AppKit.delegate
        AppKit.delegate = self
    }

    override func stop() {
        AppKit.delegate = appKitDelegate
        appKitDelegate = nil
    }

    func didFail(with error: AppKit.AppError) {
        // Add error handling
    }

    func didReceiveAppDrawers(_ appDrawers: [AppKit.AppDrawer], _ appDatas: [AppKit.AppData]) {
        // Add handling for app drawers
    }
}
