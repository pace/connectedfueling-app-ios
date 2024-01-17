import SwiftUI

struct ContentView: View {
    @Environment(\.scenePhase) var scenePhase

    @State private var selection: AppScreen = .map
    @AppStorage(UserDefaults.Key.isOnboardingCompleted) private var isOnboardingCompleted: Bool = false

    private let appManager: AppManager
    private let analyticsManager: AnalyticsManager

    init(analyticsManager: AnalyticsManager) {
        self.analyticsManager = analyticsManager
        self.appManager = .init(analyticsManager: analyticsManager)
    }

    var body: some View {
        content
            .onChange(of: scenePhase) { newPhase in
                guard newPhase == .active else { return }
                analyticsManager.logEvent(AnalyticEvents.AppOpenedEvent())
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
}
