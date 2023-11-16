import SwiftUI

struct OnboardingNavigationView: View {
    var body: some View {
        AppNavigationView {
            OnboardingView()
                .addNavigationBar()
        }
    }
}
