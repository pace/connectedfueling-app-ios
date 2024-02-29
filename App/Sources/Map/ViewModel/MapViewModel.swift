import MapKit
import PACECloudSDK
import SwiftUI

@MainActor
class MapViewModel: NSObject, ObservableObject {

    @Published var region: MKCoordinateRegion
    @Published var trackingMode: MapUserTrackingMode
    @Published var annotations: [GasStationAnnotation] = []
    @Published var isTopAnnotationHidden: Bool = false
    @Published var isSearchViewPresented: Bool = false {
        didSet {
            if isSearchViewPresented {
                trackingMode = .none
            }
        }
    }
    @Published var locationPermissionStatus: PermissionStatus {
        didSet {
            guard locationPermissionStatus != .authorized else { return }
            trackingMode = .none
        }
    }

    @Published var errorMessage: String?

    private var onShowAlert: ((_ alert: Alert) -> Void)?

    private var initialLoadingDone: Bool = false

    private var cofuStationsTask: Task<(), Never>?

    private let poiManager: POIManager
    private let locationManager: LocationManager
    private let analyticsManager: AnalyticsManager

    private var currentUserLocation: CLLocation?
    private var currentBoundingBox: POIKit.BoundingBox?
    private var distanceThresholdBeforeSearch: Double = 500 // in meters
    private var diameterThresholdBeforeSearch: Double = 100 // in meters

    private let fallbackStartLocation: CLLocationCoordinate2D = .init(latitude: 51.163375, longitude: 10.447683) // Center of Germany
    private let fallbackStartSpan: MKCoordinateSpan = .init(latitudeDelta: 10, longitudeDelta: 10) // Empirical value

    // Search
    @Published var searchResults: [MKLocalSearchCompletion] = []
    private let completer: MKLocalSearchCompleter

    init(poiManager: POIManager = .init(),
         analyticsManager: AnalyticsManager = .init(),
         locationManager: LocationManager = .shared,
         onShowAlert: ((_ alert: Alert) -> Void)? = nil) {
        self.poiManager = poiManager
        self.locationManager = locationManager
        self.analyticsManager = analyticsManager
        self.onShowAlert = onShowAlert
        let currentLocationPermissionStatus = locationManager.currentLocationPermissionStatus
        let isLocationGranted = currentLocationPermissionStatus != .denied && currentLocationPermissionStatus != .notDetermined
        self.locationPermissionStatus = currentLocationPermissionStatus
        self.trackingMode = isLocationGranted ? .follow : .none

        // Only set fallback != 0 when we do not have user location, 
        // otherwise map always starts at fallback even when user location is available and tracking set to follow
        if !isLocationGranted {
            self.region = .init(center: fallbackStartLocation, span: fallbackStartSpan)
        } else {
            self.region = .init(center: .init(latitude: 0, longitude: 0), span: .init(latitudeDelta: 0, longitudeDelta: 0))
        }

        self.completer = MKLocalSearchCompleter()

        super.init()

        self.locationManager.subscribe(self)
        completer.delegate = self
        completer.region = region
    }

    deinit {
        locationManager.unsubscribe(self)
    }

    func didChangeRegion(_ region: MKCoordinateRegion) {
        guard region.zoomLevel > 10 else {
            annotations = []
            if self.initialLoadingDone {
                self.errorMessage = L10n.zoomInNote
            }
            initialLoadingDone = true
            return
        }

        initialLoadingDone = true

        isTopAnnotationHidden = region.zoomLevel < 13

        let boundingBox = region.visibleBoundingBox(with: 0.85)

        guard shouldFetch(for: boundingBox, trackingMode: trackingMode) else { return }

        fetchCofuStations(at: boundingBox)
    }

    private func fetchCofuStations(at boundingBox: POIKit.BoundingBox) {
        currentBoundingBox = boundingBox
        let oldCurrentUserLocation = currentUserLocation
        currentUserLocation = locationManager.latestLocations.first
        var distanceToNewLocation: Double?
        if let currentUserLocation = currentUserLocation {
            distanceToNewLocation = oldCurrentUserLocation?.distance(from: currentUserLocation)
        }

        cofuStationsTask?.cancel()
        cofuStationsTask = Task { @MainActor [weak self] in
            guard let result = await self?.poiManager.fetchCofuStations(at: boundingBox,
                                                                        for: self?.currentUserLocation) else {
                return
            }

            switch result {
            case .success(let cofuStations):
                if self?.initialLoadingDone ?? false {
                    self?.errorMessage = nil // only hide error message in subsequent calls to not hide the location permission message
                }

                if self?.currentUserLocation != nil
                    && (distanceToNewLocation == nil
                        || distanceToNewLocation ?? .leastNonzeroMagnitude > Constants.Distance.formattingThresholdForMetersPrecision - Constants.Distance.roundingThreshold)
                    && cofuStations.contains(where: { $0.isNearby }) {
                    self?.analyticsManager.logEvent(AnalyticEvents.StationNearbyEvent())
                }

                self?.annotations = cofuStations.map(GasStationAnnotation.init)

            case .failure(let error):
                self?.handleError(error)
            }

            self?.initialLoadingDone = true
        }
    }

    private func handleError(_ error: Error) {
        switch error {
        case let poiKitError as POIKit.POIKitAPIError:
            switch poiKitError {
            case .operationCanceledByClient:
                break

            case .networkError:
                self.errorMessage = L10n.commonUseNetworkError

            default:
                self.errorMessage = L10n.commonUseUnknownError
            }

        default:
            self.errorMessage = L10n.commonUseUnknownError
        }
    }

    func didTriggerSearch(at coordinate: CLLocationCoordinate2D) {
        self.trackingMode = .none
        self.region = .init(center: coordinate,
                            span: .init(latitudeDelta: Constants.Map.mapSpanDelta, longitudeDelta: Constants.Map.mapSpanDelta))
        self.isSearchViewPresented = false
    }

    func onAppear() {
        locationManager.startUpdatingLocation()
        checkLocationPermission()
    }

    func checkLocationPermission() {
        locationPermissionStatus = locationManager.currentLocationPermissionStatus
        checkForLocationError(locationPermissionStatus)
    }

    private func checkForLocationError(_ locationPermissionStatus: PermissionStatus) {
        switch locationPermissionStatus {
        case .denied:
            self.errorMessage = L10n.alertLocationPermissionDeniedTitle
            return

        case .disabled:
            self.errorMessage = L10n.LocationDialog.disabledTitle
            return

        default:
            break
        }
    }

    func showLocationPermissionAlert() {
        guard locationPermissionStatus != .authorized
                || locationPermissionStatus != .notDetermined else {
            return
        }

        if locationPermissionStatus == .denied {
            onShowAlert?(AppAlert.locationPermissionDeniedError)
        } else {
            onShowAlert?(AppAlert.locationPermissionDeniedError)
        }
    }

    private func shouldFetch(for boundingBox: POIKit.BoundingBox, trackingMode: MapUserTrackingMode) -> Bool {
        guard trackingMode == .follow,
              let currentBoundingBox = self.currentBoundingBox else {
            return true
        }

        let distance = boundingBox.center.distance(from: currentBoundingBox.center)
        let diameterDifference = abs(boundingBox.diameter - currentBoundingBox.diameter)

        if
            distance > distanceThresholdBeforeSearch
                || diameterDifference > diameterThresholdBeforeSearch
        {
            return true
        }

        return false
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

// MARK: LocationManagerDelegate

extension MapViewModel: LocationManagerDelegate {
    func didUpdateLocations(locations: [CLLocation]) {}
    
    func didFail(with error: Error) {}
    
    func didChangePermissionStatus(newStatus: PermissionStatus) {
        locationPermissionStatus = newStatus
        checkForLocationError(newStatus)
    }
}
