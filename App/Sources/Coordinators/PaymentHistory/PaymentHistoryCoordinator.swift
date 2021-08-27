import Domain
import JLCoordinator
import PACECloudSDK
import UIKit

final class PaymentHistoryCoordinator: Coordinator {
    typealias Callback = () -> Void

    private let callback: Callback?
    private lazy var viewController: AppViewController = AppKit.appViewController(
        presetUrl: .transactions,
        completion: callback
    )
    private lazy var receiptCoordinator: PaymentReceiptCoordinator = .init(
        presenter: ModalPresenter(presentingViewController: viewController)
    )

    init(presenter: Presenter, callback: Callback? = nil) {
        self.callback = callback

        super.init(presenter: presenter)
    }

    override func start() {
        presenter.present(viewController, animated: true)
        receiptCoordinator.start()
    }
}
