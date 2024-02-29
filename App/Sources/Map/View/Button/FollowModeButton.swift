import MapKit
import SwiftUI

extension MapView {
    struct FollowModeButton: View {
        @Binding private var trackingMode: MapUserTrackingMode
        @Binding private var locationPermissionStatus: PermissionStatus
        @Binding private var errorMessage: String?
        @State private var trackingModeImage: ImageResource
        private var showLocationAlert: () -> Void

        private let locationManager: LocationManager

        private var isLocationAuthorized: Bool {
            return locationPermissionStatus == .authorized || locationPermissionStatus == .notDetermined
        }

        private var isLocationPermissionDenied: Bool {
            return locationPermissionStatus == .denied
        }

        init(trackingMode: Binding<MapUserTrackingMode>,
             locationPermissionStatus: Binding<PermissionStatus>,
             errorMessage: Binding<String?>,
             showLocationAlert: @escaping () -> Void,
             locationManager: LocationManager = .shared) {
            self._trackingMode = trackingMode
            self._locationPermissionStatus = locationPermissionStatus
            self._errorMessage = errorMessage
            self.locationManager = locationManager
            self._trackingModeImage = trackingMode.wrappedValue == .follow ? .init(wrappedValue: .mapFollowModeIcon) : .init(wrappedValue: .mapFollowModeNoneIcon)
            self.showLocationAlert = showLocationAlert
        }

        var body: some View {
            Button(action: changeTrackingMode) {
                HStack(spacing: 0) {
                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .frame(alignment: .trailing)
                            .lineLimit(nil)
                            .multilineTextAlignment(.leading)
                            .padding([.leading, .vertical])
                            .font(.system(size: 14))
                    }
                    ZStack {
                        Circle()
                            .frame(width: 50, height: 50)
                            .foregroundStyle(Color.genericWhite)
                        Image(trackingModeImage)
                            .renderingMode(.template)
                            .frame(width: 32, height: 32)
                            .tint(!isLocationAuthorized ? Color.genericRed : Color.genericGrey)
                    }
                }
            }.onChange(of: trackingMode) { _ in
                updateTrackingModeImage()
            }
            .background(Color.genericWhite)
            .cornerRadius(errorMessage != nil ? .cornerRadius : 60)
            .addShadow()
            .padding(.leading)
        }

        func changeTrackingMode() {
            guard isLocationAuthorized else {
                showLocationAlert()
                return
            }

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
    MapView.FollowModeButton(trackingMode: .constant(.none), locationPermissionStatus: .constant(.authorized), errorMessage: .constant(nil), showLocationAlert: {})
}
