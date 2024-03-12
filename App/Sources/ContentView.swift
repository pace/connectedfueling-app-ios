import SwiftUI

struct ContentView: View {
    @Environment(\.scenePhase) var scenePhase

    @State private var selection: AppScreen = .gasStationList
    @State private var consentUpdatedPages: ConsentUpdateViewModel.ConsentUpdatePages?
    @AppStorage(UserDefaults.Key.isOnboardingCompleted) private var isOnboardingCompleted: Bool = false

    private let appManager: AppManager
    private let analyticsManager: AnalyticsManager
    private let locationManager: LocationManager
    private let consentManager: ConsentManager
    private let notificationManager: NotificationManager

    init(analyticsManager: AnalyticsManager,
         locationManager: LocationManager = .shared,
         consentManager: ConsentManager = .init(),
         notificationManager: NotificationManager = .init()) {
        self.analyticsManager = analyticsManager
        self.consentManager = consentManager
        self.appManager = .init(analyticsManager: analyticsManager)
        self.locationManager = locationManager
        self.notificationManager = notificationManager
    }

    var body: some View {
        content
            .onChange(of: scenePhase) { newPhase in
                guard newPhase == .active else { return }
                analyticsManager.logEvent(AnalyticEvents.AppOpenedEvent())

                checkLocationStatus()
            }
            .task {
                var pages = await consentUpdatePages()

                let currentNotificationPermissionStatus = await notificationManager.currentNotificationPermissionStatus()

                if isOnboardingCompleted
                    && ConfigurationManager.configuration.isAnalyticsEnabled
                    && currentNotificationPermissionStatus == .notDetermined {
                    pages.insert(.notifications)
                }

                guard !pages.isEmpty else {
                    consentUpdatedPages = nil
                    return
                }

                consentUpdatedPages = pages

            }
            .fullScreenCover(item: $consentUpdatedPages) { pages in
                ConsentUpdateView(pages: pages, analyticsManager: analyticsManager) {
                    consentUpdatedPages = nil
                }
            }
    }

    @ViewBuilder
    private var content: some View {
        if isOnboardingCompleted {
            tabView
                .pagingTransition()
        } else {
            onboarding
                .pagingTransition()
        }
    }

    @ViewBuilder
    private var tabView: some View {
        AppTabView(selection: $selection, analyticsManager: analyticsManager)
    }

    @ViewBuilder
    private var onboarding: some View {
        OnboardingNavigationView(analyticsManager: analyticsManager)
    }

    private func checkLocationStatus() {
        let locationPermissionStatus = locationManager.currentLocationPermissionStatus

        guard locationPermissionStatus == .notDetermined, isOnboardingCompleted else { return }

        CofuLogger.i("Location permission set to ask again. Requesting permission again.")

        locationManager.requestLocationPermission { permissionStatus in
            CofuLogger.i("Location permission status: \(permissionStatus)")
        }
    }

    private func consentUpdatePages() async -> ConsentUpdateViewModel.ConsentUpdatePages {
        var pages: ConsentUpdateViewModel.ConsentUpdatePages = []
        var consentStatuses = await consentManager.checkForUpdates()

        guard let consentStatuses = consentStatuses else {
            return pages
        }

        if consentStatuses.terms == .changed {
            pages.insert(.terms)
        } else if consentStatuses.terms == .new {
            consentManager.accept(.terms)
        }

        if consentStatuses.dataPrivacy == .changed {
            pages.insert(.dataPrivacy)
        } else if consentStatuses.dataPrivacy == .new {
            consentManager.accept(.dataPrivacy)
        }

        if consentStatuses.tracking == .new
            || consentStatuses.tracking == .changed {
            pages.insert(.tracking)
        }

        return pages
    }
}
