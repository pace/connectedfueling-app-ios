import SwiftUI

extension View {
    @ViewBuilder
    func addNavigationBar(showsLogo: Bool = true, navigationTitle: String? = nil) -> some View {
        self.navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    if showsLogo {
                        Image(.logo)
                    } else if let navigationTitle {
                        Text(navigationTitle)
                            .font(.system(size: 18, weight: .medium))
                    } else {
                        Text("") // Add empty text to make the navigation visible
                    }
                }
            }
    }

    func addShadow() -> some View {
        self.shadow(color: .shadow, radius: 5, x: 0, y: 0)
    }
}
