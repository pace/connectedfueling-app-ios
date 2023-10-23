import SwiftUI

struct AppNavigationView<Content>: View where Content: View {
    private let content: () -> Content

    init(content: @escaping () -> Content) {
        self.content = content
    }

    var body: some View {
        NavigationView {
            content()
        }
        .accentColor(Color.textLight)
    }
}
