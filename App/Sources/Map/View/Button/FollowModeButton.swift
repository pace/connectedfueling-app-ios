import MapKit
import SwiftUI

extension MapView {
    struct FollowModeButton: View {
        @Binding private var trackingMode: MapUserTrackingMode
        @State private var trackingModeImage: ImageResource = .mapFollowModeIcon

        init(trackingMode: Binding<MapUserTrackingMode>) {
            self._trackingMode = trackingMode
        }

        var body: some View {
            MapButton(icon: $trackingModeImage,
                      action: changeTrackingMode)
            .onChange(of: trackingMode) { _ in
                updateTrackingModeImage()
            }
        }

        func changeTrackingMode() {
            if trackingMode == .none {
                trackingMode = .follow
            } else {
                trackingMode = .none
            }
        }

        func updateTrackingModeImage() {
            switch trackingMode {
            case .none:
                trackingModeImage = .mapFollowModeNoneIcon

            case .follow:
                trackingModeImage = .mapFollowModeIcon

            default:
                trackingModeImage = .mapFollowModeNoneIcon
            }
        }
    }
}

#Preview {
    MapView.FollowModeButton(trackingMode: .constant(.none))
}
