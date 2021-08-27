import JamitFoundation
import UIKit
import WebKit

final class DocumentViewController: StatefulViewController<DocumentViewModel> {
    @IBOutlet private var webView: WKWebView!

    override func didChangeModel() {
        super.didChangeModel()

        model.content.flatMap { content in
            webView.stopLoading()
            webView.loadHTMLString(content, baseURL: nil)
        }
    }

    @IBAction private func didTriggerCloseButton(_ sender: Any) {
        model.closeAction?()
    }
}
