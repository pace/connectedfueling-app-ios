import MapKit
import SwiftUI

extension MapView {
    struct MapButton: View {
        @Binding private var icon: ImageResource
        private let action: () -> Void

        init(icon: Binding<ImageResource>, action: @escaping () -> Void) {
            self._icon = icon
            self.action = action
        }

        var body: some View {
            Button(action: action) {
                ZStack {
                    Circle()
                        .frame(width: 50, height: 50)
                        .foregroundStyle(Color.genericWhite)
                        .addShadow()
                    Image(icon)
                        .frame(width: 32, height: 32)
                }
            }
        }
    }
}

#Preview {
    VStack {
        MapView.MapButton(icon: .constant(.mapSearchIcon), action: {})
    }
}
