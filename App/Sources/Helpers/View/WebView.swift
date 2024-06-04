import SwiftUI
import UIKit
import WebKit

struct WebView: UIViewRepresentable, Identifiable {
    let id: UUID = .init()
    let delegate: WKNavigationDelegate?

    private let htmlString: String

    init(htmlString: String, delegate: WKNavigationDelegate? = nil) {
        self.htmlString = htmlString
        self.delegate = delegate
    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView(frame: .zero, configuration: .init())
        webView.backgroundColor = UIColor(Color.genericWhite)
        webView.isOpaque = false
        webView.loadHTMLString(htmlString, baseURL: nil)
        webView.navigationDelegate = delegate
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<WebView>) {}
}
