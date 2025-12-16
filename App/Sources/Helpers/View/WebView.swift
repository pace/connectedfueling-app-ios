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
        webView.scrollView.clipsToBounds = false
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<WebView>) {}
}

struct WebSheetContainer: View {
    @Environment(\.dismiss) private var dismiss
    let webView: WebView // or the actual type of viewModel.webView

    var body: some View {
        NavigationView {
            VStack {
                webView
            }.toolbar {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                }
                .background(Color.clear)
                .buttonStyle(.plain) // keeps the floating look
                .accessibilityLabel("Close")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.primary)
                .padding(10)
                .background(.ultraThinMaterial, in: Circle())
            }
        }
    }
}
