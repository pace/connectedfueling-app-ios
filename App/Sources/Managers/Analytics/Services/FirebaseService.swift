#if ANALYTICS

import Firebase
import FirebaseInAppMessaging
import FirebaseMessaging
import UIKit
import UserNotifications

extension AnalyticsManager {
    class FirebaseService: NSObject, AnalyticsService {
        private var isActive: Bool {
            UserDefaults.isAnalyticsAllowed
        }

        func setup() {
            if FirebaseApp.app() == nil {
                FirebaseApp.configure()
            }

            Analytics.setAnalyticsCollectionEnabled(isActive)
            updateMessagingState()
        }

        func updateActivationState() {
            Analytics.setAnalyticsCollectionEnabled(isActive)
            updateMessagingState()
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

        private func updateMessagingState() {
            let isAnalyticsAllowed = isActive

            // Cloud Messaging / Push Notifications
            Messaging.messaging().delegate = isAnalyticsAllowed ? self : nil
            UNUserNotificationCenter.current().delegate = isAnalyticsAllowed ? self : nil

            if isAnalyticsAllowed {
                UIApplication.shared.registerForRemoteNotifications()
            } else {
                UIApplication.shared.unregisterForRemoteNotifications()
            }

            // In App Messaging
            InAppMessaging.inAppMessaging().delegate = isAnalyticsAllowed ? self : nil
        }
    }
}

// MARK: - User Notification Delegate
extension AnalyticsManager.FirebaseService: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        return [.list, .banner, .sound]
    }
}

// MARK: - Firebase Cloud Messaging
extension AnalyticsManager.FirebaseService: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard fcmToken != nil else { return }
        CofuLogger.i("[FirebaseMessagingService] Did receive FCM registration token")
    }
}

// MARK: - Firebase In-App Messaging
extension AnalyticsManager.FirebaseService: InAppMessagingDisplayDelegate {
    func messageClicked(_ inAppMessage: InAppMessagingDisplayMessage) {
        CofuLogger.i("[FirebaseMessagingService] In-App-Message clicked")
    }

    func messageDismissed(_ inAppMessage: InAppMessagingDisplayMessage,
                          dismissType: FIRInAppMessagingDismissType) {
        CofuLogger.i("[FirebaseMessagingService] In-App-Message dismissed")
    }

    func impressionDetected(for inAppMessage: InAppMessagingDisplayMessage) {
        CofuLogger.i("[FirebaseMessagingService] In-App-Message impression detected")
    }

    func displayError(for inAppMessage: InAppMessagingDisplayMessage, error: Error) {
        CofuLogger.e("[FirebaseMessagingService] In-App-Message display error \(error)")
    }
}

#endif
