import Foundation
import PACECloudSDK

class AppManager {

    private let analyticsManager: AnalyticsManager

    init(analyticsManager: AnalyticsManager) {
        self.analyticsManager = analyticsManager
        AppKit.delegate = self
    }
}

extension AppManager: AppKitDelegate {
    func logEvent(key: String, parameters: [String: Any]) {
        switch key {
        case "payment_method_added":
            let paymentMethodKind = parameters["kind"] as? String
            analyticsManager.logEvent(AnalyticEvents.CardBoardingDoneEvent(type: paymentMethodKind ?? ""))

        case "payment_method_creation_started":
            analyticsManager.logEvent(AnalyticEvents.CardBoardingStartedEvent())

        case "fueling_canceled", "fueling_ended":
            analyticsManager.logEvent(key: key, parameters: parameters)

        default:
            break
        }
    }
}
