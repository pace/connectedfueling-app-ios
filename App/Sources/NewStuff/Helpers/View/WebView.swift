import SwiftUI
import UIKit
import WebKit

struct WebView: UIViewRepresentable, Identifiable {
    let id: UUID = .init()

    private let htmlString: String

    init(htmlString: String) {
        self.htmlString = htmlString
    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView(frame: .zero, configuration: .init())
        webView.backgroundColor = UIColor(Color.genericWhite)
        webView.isOpaque = false
        webView.loadHTMLString(htmlString, baseURL: nil)
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<WebView>) {}
}
