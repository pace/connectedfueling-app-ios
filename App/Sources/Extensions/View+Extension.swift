import SwiftUI

// MARK: - Navigation Bar
extension View {
    @ViewBuilder
    func addNavigationBar(style: NavigationBarStyle, backgroundColor: Color = .genericWhite) -> some View {
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
            .navigationBarBackground {
                backgroundColor
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

// MARK: - Customisable NavigationBar background color

public extension View {
    func navigationBarBackground<Background: View>(@ViewBuilder _ background: @escaping () -> Background) -> some View {
        modifier(NavigationBarColorModifier(background: background))
    }
}

public extension View {
    func navigationTransparentBar() -> some View {
        modifier(NavigationBarTransparentStyle())
    }
}
