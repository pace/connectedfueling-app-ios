import SwiftUI

// MARK: - Navigation Bar
extension View {
    @ViewBuilder
    func addNavigationBar(style: NavigationBarStyle) -> some View {
        self.navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    switch style {
                    case .standard(let title):
                        TextLabel(title ?? "")
                            .font(.system(size: 18, weight: .bold))

                    case .centeredIcon(let icon):
                        Image(icon)
                    }
                }
            }
    }

    @ViewBuilder
    func pagingTransition() -> some View {
        self.transition(.asymmetric(
            insertion: .move(edge: .trailing),
            removal: .move(edge: .leading))
        )
        .animation(.default)
    }
}

extension View {
    @ViewBuilder
    func addShadow() -> some View {
        self.shadow(color: .shadow, radius: 5, x: 0, y: 0)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}
