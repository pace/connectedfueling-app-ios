import Foundation

// swiftlint:disable type_name
class OnboardingNotificationPermissionPageViewModel: OnboardingPageViewModel {
    private let notificationManager: NotificationManager

    init(style: ConfigurationManager.Configuration.OnboardingStyle,
         notificationManager: NotificationManager = .init()) {
        self.notificationManager = notificationManager

        super.init(style: style,
                   image: .onboardingNotificationIcon,
                   title: L10n.onboardingNotificationPermissionTitle,
                   description: L10n.onboardingNotificationPermissionDescription)
    }

    override func setupPageActions() {
        pageActions = [
            .init(title: L10n.commonUseNext, action: { [weak self] in
                self?.requestNotificationPermission()
            })
        ]
    }

    override func isPageAlreadyCompleted() async -> Bool {
        await notificationManager.currentNotificationPermissionStatus() != .notDetermined
    }

    private func requestNotificationPermission() {
        Task { @MainActor [weak self] in
            _ = await self?.notificationManager.requestNotificationAuthorization()
            self?.finishOnboardingPage()
        }
    }
}
