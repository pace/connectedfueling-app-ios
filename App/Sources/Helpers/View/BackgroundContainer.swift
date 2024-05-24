import SwiftUI

struct BackgroundContainer: View {
    var body: some View {
        Rectangle()
            .foregroundStyle(Color.genericWhite)
            .cornerRadius(12)
            .addShadow()
    }
}

#Preview {
    BackgroundContainer()
}
