import SwiftUI

struct ListItemIconView: View {
    private let icon: ImageResource

    init(_ icon: ImageResource) {
        self.icon = icon
    }

    var body: some View {
        Image(icon)
            .resizable()
            .frame(width: 20, height: 20)
    }
}

#Preview {
    ListItemIconView(.walletTabIcon)
}
