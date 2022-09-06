import JamitFoundation
import UIKit
import WebKit

final class DocumentViewController: CofuViewController<DocumentViewModel> {
    private lazy var webView: WKWebView = {
        let webView: WKWebView = .instantiate()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()

    private lazy var closeButton: UIButton = {
        let button: UIButton = .instantiate()
        button.setImage(Asset.Images.closeIcon.image, for: .normal)
        button.addTarget(self, action: #selector(didTriggerCloseButton(_:)), for: .primaryActionTriggered)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func didChangeModel() {
        super.didChangeModel()

        model.content.flatMap { content in
            webView.stopLoading()
            webView.loadHTMLString(content, baseURL: nil)
        }
    }

    override func setup() {
        view.backgroundColor = .white

        [
            closeButton,
            webView
        ].forEach(view.addSubview)

        closeButton.trailingAnchor.constraint(greaterThanOrEqualTo: view.trailingAnchor, constant: -16).isActive = true
        closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        closeButton.bottomAnchor.constraint(equalTo: webView.topAnchor, constant: -16).isActive = true

        webView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        webView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    @objc
    private func didTriggerCloseButton(_ sender: Any) {
        model.closeAction?()
    }
}
