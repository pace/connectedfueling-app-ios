#if ANALYTICS

import Firebase
import Foundation

extension AnalyticsManager {
    struct FirebaseService: AnalyticsService {

        var isActive: Bool {
            UserDefaults.isAnalyticsAllowed
        }

        func setup() {
            if FirebaseApp.app() == nil {
                FirebaseApp.configure()
            }

            Analytics.setAnalyticsCollectionEnabled(isActive)
        }

        func updateActivationState() {
            Analytics.setAnalyticsCollectionEnabled(isActive)
        }

        func logEvent(_ event: AnalyticEvent) {
            guard isActive else {
                CofuLogger.i("[FirebaseAnalyticsService] Event with key \(event.key) not sent. Reason: Analytics disabled.")
                return
            }
            
            Analytics.logEvent(event.key, parameters: event.parameters)

            guard let params = event.parameters else {
                CofuLogger.i("[FirebaseAnalyticsService] Sent Event with key \(event.key).")
                return
            }

            CofuLogger.i("[FirebaseAnalyticsService] Sent Event with key \(event.key) and parameters \(params).")
        }

        func logEvent(key: String, parameters: [String: Any]) {
            guard isActive else {
                CofuLogger.i("[FirebaseAnalyticsService] Event with key \(key) not sent. Reason: Analytics disabled.")
                return
            }

            Analytics.logEvent(key, parameters: parameters)

            CofuLogger.i("[FirebaseAnalyticsService] Sent Event with key \(key) and parameters \(parameters).")
        }
    }
}

#endif
