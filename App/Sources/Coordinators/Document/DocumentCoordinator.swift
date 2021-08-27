import JamitFoundation
import JLCoordinator
import UIKit

final class DocumentCoordinator: Coordinator {
    enum Document: String {
        case imprint
        case privacy
    }

    private let document: Document
    private lazy var viewController: DocumentViewController = .instantiate()

    init(document: Document, presenter: Presenter) {
        self.document = document

        super.init(presenter: presenter)
    }

    override func start() {
        let url = Bundle.main.url(forResource: document.rawValue, withExtension: "html")
        let content = try? url.flatMap(String.init(contentsOf:))

        viewController.model = .init(
            content: content
        ) { [weak self] in
            self?.closeViewController()
        }

        presenter.present(viewController, animated: true)
    }

    private func closeViewController() {
        presenter.dismiss(viewController, animated: true)
    }

    override func presenter(_ presenter: Presenter, didDismiss viewController: UIViewController) {
        guard viewController === self.viewController else { return }

        stop()
    }
}
