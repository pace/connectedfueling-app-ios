import SwiftUI

struct ContentView: View {
    @StateObject private var onboardingViewModel: OnboardingViewModel = .init()
    @State private var selection: AppScreen = .gasStationList

    private let appManager: AppManager = .init()

    var body: some View {
        if onboardingViewModel.isOnboardingCompleted {
            tabView
        } else {
            onboarding
        }
    }

    @ViewBuilder
    private var tabView: some View {
        AppTabView(selection: $selection)
    }

    @ViewBuilder
    private var onboarding: some View {
        OnboardingNavigationView(onboardingViewModel: onboardingViewModel)
    }
}
