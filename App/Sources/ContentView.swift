import SwiftUI

struct ContentView: View {
    @Environment(\.scenePhase) var scenePhase

    @State private var selection: AppScreen = .gasStationList
    @State private var legalUpdatedPages: LegalUpdateViewModel.LegalUpdatePages?
    @AppStorage(UserDefaults.Key.isOnboardingCompleted) private var isOnboardingCompleted: Bool = false

    private let appManager: AppManager
    private let analyticsManager: AnalyticsManager
    private let locationManager: LocationManager
    private let legalManager: LegalManager

    init(analyticsManager: AnalyticsManager,
         locationManager: LocationManager = .shared,
         legalManager: LegalManager = .init()) {
        self.analyticsManager = analyticsManager
        self.legalManager = legalManager
        self.appManager = .init(analyticsManager: analyticsManager)
        self.locationManager = locationManager
    }

    var body: some View {
        content
            .onChange(of: scenePhase) { newPhase in
                guard newPhase == .active else { return }
                analyticsManager.logEvent(AnalyticEvents.AppOpenedEvent())

                checkLocationStatus()
            }
            .task {
                let legalDocumentsStatus = await legalManager.checkForUpdates()

                guard let legalDocumentsStatus = legalDocumentsStatus else {
                    legalUpdatedPages = nil
                    return
                }

                var pages: LegalUpdateViewModel.LegalUpdatePages = []

                if legalDocumentsStatus.terms == .changed {
                    pages.insert(.terms)
                } else if legalDocumentsStatus.terms == .new {
                    legalManager.accept(.terms)
                }

                if legalDocumentsStatus.dataPrivacy == .changed {
                    pages.insert(.dataPrivacy)
                } else if legalDocumentsStatus.dataPrivacy == .new {
                    legalManager.accept(.dataPrivacy)
                }

                if legalDocumentsStatus.tracking == .new
                    || legalDocumentsStatus.tracking == .changed {
                    pages.insert(.tracking)
                }

                guard !pages.isEmpty else {
                    legalUpdatedPages = nil
                    return
                }

                legalUpdatedPages = pages

            }
            .fullScreenCover(item: $legalUpdatedPages) { pages in
                LegalUpdateView(pages: pages, analyticsManager: analyticsManager) {
                    legalUpdatedPages = nil
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
}
