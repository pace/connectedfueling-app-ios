import SwiftUI

struct ContentView: View {
    @State private var selection: AppScreen = .map
    @AppStorage(Constants.UserDefaults.isOnboardingCompleted) private var isOnboardingCompleted: Bool = false

    private let appManager: AppManager

    init() {
        self.appManager = .init()
    }

    var body: some View {
        if isOnboardingCompleted {
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
        OnboardingNavigationView()
    }
}
