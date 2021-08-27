import Domain
import JLCoordinator
import PACECloudSDK
import UIKit

final class PaymentReceiptCoordinator: Coordinator, AppKitDelegate {
    private var appKitDelegate: AppKitDelegate? // swiftlint:disable:this weak_delegate

    override func start() {
        appKitDelegate = AppKit.delegate
        AppKit.delegate = self
    }

    override func stop() {
        AppKit.delegate = appKitDelegate
        appKitDelegate = nil
    }

    func didReceiveImageData(_ image: UIImage) {
        let viewController = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )

        presenter.present(viewController, animated: true)
    }

    func didFail(with error: AppKit.AppError) {
        // Add error handling
    }

    func didReceiveAppDrawers(_ appDrawers: [AppKit.AppDrawer], _ appDatas: [AppKit.AppData]) {
        // Add handling for app drawers
    }
}
