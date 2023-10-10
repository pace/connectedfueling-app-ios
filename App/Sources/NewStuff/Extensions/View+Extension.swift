import SwiftUI

extension View {
    @ViewBuilder
    func addNavigationBar(showsLogo: Bool = true) -> some View {
        self.navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    if showsLogo {
                        Image(.logo)
                    } else {
                        Text("")
                    }
                }
            }
    }
}
