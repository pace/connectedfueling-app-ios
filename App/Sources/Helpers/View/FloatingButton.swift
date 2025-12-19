import SwiftUI

struct FloatingCloseButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(10)
            .background(.ultraThinMaterial, in: Circle())
    }
}
