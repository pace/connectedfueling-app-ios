import SwiftUI

class NotificationConsentPageViewModel: ConsentUpdatePageViewModel {
    private let notificationManager: NotificationManager

    init(notificationManager: NotificationManager = .init()) {
        self.notificationManager = notificationManager
        super.init(title: L10n.notificationPermissionRequestTitle,
                   description: L10n.onboardingNotificationPermissionDescription)
    }

    override func setupPageActions() {
        pageActions = [
            .init(title: L10n.commonUseNext, action: { [weak self] in
                self?.requestNotificationPermission()
            })
        ]
    }

    private func requestNotificationPermission() {
        Task { @MainActor [weak self] in
            _ = await self?.notificationManager.requestNotificationAuthorization()
            self?.finishConsentUpdatePage()
        }
    }
}
