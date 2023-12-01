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
}

extension View {
    @ViewBuilder
    func addShadow() -> some View {
        self.shadow(color: .shadow, radius: 5, x: 0, y: 0)
    }
}
