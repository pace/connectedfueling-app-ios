// Copyright © 2023 PACE Telematics GmbH. All rights reserved.

import PACECloudSDK
import SwiftUI

struct AppView: UIViewControllerRepresentable {
    private let urlString: String

    init(urlString: String) {
        self.urlString = urlString
    }

    func makeUIViewController(context: Context) -> AppViewController {
        AppKit.appViewController(appUrl: urlString)
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}
