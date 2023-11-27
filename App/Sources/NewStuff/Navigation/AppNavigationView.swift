import SwiftUI

struct AppNavigationView<Content>: View where Content: View {
    private let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        NavigationView {
            content
        }
        .accentColor(.white)
    }
}
