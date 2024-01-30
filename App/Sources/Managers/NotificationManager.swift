import UserNotifications

struct NotificationManager {
    private let notificationOptions: UNAuthorizationOptions = [.alert, .sound, .badge]
    private let center = UNUserNotificationCenter.current()

    func currentNotificationPermissionStatus() async -> PermissionStatus {
        let status = await center.notificationSettings().authorizationStatus
        let mappedStatus = makeNotificationPermissionStatus(for: status)
        return mappedStatus
    }

    func requestNotificationAuthorization() async -> Bool {
        do {
            let status = try await center.requestAuthorization(options: notificationOptions)
            CofuLogger.e("[NotificationManager] Successfully requested authorization; granted \(status)")

            return status
        } catch {
            CofuLogger.e("[NotificationManager] Failed requesting authorization with error \(error)")
            return false
        }
    }
}

private extension NotificationManager {
    func makeNotificationPermissionStatus(for authorizationStatus: UNAuthorizationStatus) -> PermissionStatus {
        switch authorizationStatus {
        case .notDetermined:
            return .notDetermined

        case .denied:
            return .denied

        case .authorized, .provisional, .ephemeral:
            return .authorized

        @unknown default:
            return .denied
        }
    }
}
