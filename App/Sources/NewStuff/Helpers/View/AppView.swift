import PACECloudSDK
import SwiftUI

struct AppView: UIViewControllerRepresentable {
    private let urlString: String
    private let completion: (() -> Void)?

    init(urlString: String, completion: (() -> Void)? = nil) {
        self.urlString = urlString
        self.completion = completion
    }

    func makeUIViewController(context: Context) -> AppViewController {
        AppKit.appViewController(appUrl: urlString, completion: completion)
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}
