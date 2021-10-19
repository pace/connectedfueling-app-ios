import Domain
import JLCoordinator
import PACECloudSDK
import UIKit

final class PaymentMethodCoordinator: Coordinator {
    typealias Callback = () -> Void

    private let callback: Callback?
    private lazy var viewController: AppViewController = AppKit.appViewController(
        presetUrl: .payment,
        isModalInPresentation: false,
        completion: callback
    )

    init(presenter: Presenter, callback: Callback? = nil) {
        self.callback = callback

        super.init(presenter: presenter)
    }

    override func start() {
        presenter.present(viewController, animated: true)
    }
}
