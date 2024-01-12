import MapKit
import SwiftUI

@MainActor
class MapViewModel: NSObject, ObservableObject {
    @Published var region: MKCoordinateRegion
    @Published var trackingMode: MapUserTrackingMode = .follow
    @Published var annotations: [GasStationAnnotation] = []
    @Published var isTopAnnotationHidden: Bool = false
    @Published var isSearchViewPresented: Bool = false {
        didSet {
            if isSearchViewPresented {
                trackingMode = .none
            }
        }
    }

    private var currentLocation: CLLocation?
    private var previousLocation: CLLocation?

    private var cofuStationsTask: Task<(), Never>?

    private let poiManager: POIManager

    // Search
    @Published var searchResults: [MKLocalSearchCompletion] = []
    private let completer: MKLocalSearchCompleter

    init(poiManager: POIManager = .init()) {
        self.poiManager = poiManager
        self.region = .init(center: .init(latitude: 0, longitude: 0),
                            span: .init(latitudeDelta: 0, longitudeDelta: 0))
        self.completer = MKLocalSearchCompleter()

        super.init()

        completer.delegate = self
        completer.region = region
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
                CofuLogger.e("[MapViewModel] Failed fetching cofu stations with error \(error)")
            }
        }
    }

    func didTriggerSearch(at coordinate: CLLocationCoordinate2D) {
            self.trackingMode = .none
            self.region = .init(center: coordinate,
                           span: .init(latitudeDelta: Constants.Map.mapSpanDelta, longitudeDelta: Constants.Map.mapSpanDelta))
            self.isSearchViewPresented = false
    }
}

// MARK: - Search

extension MapViewModel {
    func completeSearch(for text: String) {
        if text.isEmpty {
            searchResults = []
            return
        }

        completer.cancel()
        completer.queryFragment = text
    }

    func search(for text: String) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = text
        searchRequest.region = region
        search(for: searchRequest)
    }

    func search(for searchCompletion: MKLocalSearchCompletion) {
        let searchRequest = MKLocalSearch.Request(completion: searchCompletion)
        searchRequest.region = region
        search(for: searchRequest)
    }

    private func search(for request: MKLocalSearch.Request) {
        let search = MKLocalSearch(request: request)
        search.start { [weak self] response, error in
            if let error {
                CofuLogger.e("[MapViewModel] Search failed with error \(error)")
                return
            }

            guard let response = response,
                  let searchItemCoordinate = response.mapItems.first?.placemark.location?.coordinate else {
                CofuLogger.w("[MapViewModel] Search response invalid")
                return
            }

            self?.didTriggerSearch(at: searchItemCoordinate)
        }
    }
}

extension MapViewModel: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = Array(completer.results.prefix(5))
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        CofuLogger.e("[MapViewModel] Search completer did fail with error \(error)")
    }
}
