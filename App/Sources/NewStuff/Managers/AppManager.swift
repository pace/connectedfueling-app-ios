import Foundation
import PACECloudSDK

class AppManager {
    init() {
        AppKit.delegate = self
    }
}

extension AppManager: AppKitDelegate {}
