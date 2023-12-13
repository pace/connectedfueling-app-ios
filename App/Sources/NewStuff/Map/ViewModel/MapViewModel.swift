import MapKit
import SwiftUI

class MapViewModel: ObservableObject {
    @Published var region: MKCoordinateRegion
    @Published var trackingMode: MapUserTrackingMode = .follow
    @Published var annotations: [GasStationAnnotation] = []
    @Published var isTopAnnotationHidden: Bool = false
    @Published var isSearchViewPresented: Bool = false

    private var currentLocation: CLLocation?
    private var previousLocation: CLLocation?

    private var cofuStationsTask: Task<(), Never>?

    private let poiManager: POIManager

    init(poiManager: POIManager = .init()) {
        self.poiManager = poiManager
        self.region = .init(center: .init(latitude: 0, longitude: 0),
                            span: .init(latitudeDelta: 0, longitudeDelta: 0))
    }

    func didChangeRegion(_ region: MKCoordinateRegion) {
        isTopAnnotationHidden = region.zoomLevel < 14

        cofuStationsTask?.cancel()
        cofuStationsTask = Task { @MainActor [weak self] in
            let location: CLLocation = .init(latitude: region.center.latitude, longitude: region.center.longitude)

            guard let result = await self?.poiManager.fetchCofuStations(at: location) else { return }

            switch result {
            case .success(let cofuStations):
                self?.annotations = cofuStations.map(GasStationAnnotation.init)

            case .failure(let error):
                NSLog("[MapViewModel] Failed fetching cofu stations with error \(error)")
            }
        }
    }

    func didTriggerSearch(at coordinate: CLLocationCoordinate2D) {
        trackingMode = .none
        region = .init(center: coordinate,
                       span: .init(latitudeDelta: Constants.Map.mapSpanDelta, longitudeDelta: Constants.Map.mapSpanDelta))
        isSearchViewPresented = false
    }
}
