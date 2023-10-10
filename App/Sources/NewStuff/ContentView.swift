import SwiftUI

struct ContentView: View {
    @StateObject private var onboardingViewModel: OnboardingViewModel = .init()

    private let appManager: AppManager = .init()

    var body: some View {
        if onboardingViewModel.isOnboardingCompleted {
            tabView
                .animation(.default)
        } else {
            onboarding
        }
    }

    @ViewBuilder
    private var tabView: some View {
        TabView {
            GasStationListView()
                .tabItem {
                    Label("Gas Station List", systemImage: "list.dash")
                }
        }
    }

    @ViewBuilder
    private var onboarding: some View {
        OnboardingView(viewModel: onboardingViewModel)
    }
}
