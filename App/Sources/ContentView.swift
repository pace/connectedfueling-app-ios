import SwiftUI

struct ContentView: View {
    @Environment(\.scenePhase) var scenePhase

    @State private var selection: AppScreen = .gasStationList
    @AppStorage(UserDefaults.Key.isOnboardingCompleted) private var isOnboardingCompleted: Bool = false

    private let appManager: AppManager
    private let analyticsManager: AnalyticsManager
    private let locationManager: LocationManager

    init(analyticsManager: AnalyticsManager, locationManager: LocationManager = .shared) {
        self.analyticsManager = analyticsManager
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
