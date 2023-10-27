import PACECloudSDK
import SwiftUI

struct AppView: UIViewControllerRepresentable {
    private let urlString: String
    private let isModalInPresentation: Bool
    private let completion: (() -> Void)?

    init(urlString: String, isModalInPresentation: Bool = false, completion: (() -> Void)? = nil) {
        self.urlString = urlString
        self.isModalInPresentation = isModalInPresentation
        self.completion = completion
    }

    func makeUIViewController(context: Context) -> AppViewController {
        AppKit.appViewController(appUrl: urlString, isModalInPresentation: isModalInPresentation, completion: completion)
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}
