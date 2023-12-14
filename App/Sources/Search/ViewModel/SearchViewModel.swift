import Foundation
import MapKit

class SearchViewModel: NSObject, ObservableObject {
    @Published var searchResults: [MKLocalSearchCompletion] = []

    private let region: MKCoordinateRegion
    private let onSearch: (CLLocationCoordinate2D) -> Void

    private let completer: MKLocalSearchCompleter

    init(region: MKCoordinateRegion, onSearch: @escaping (CLLocationCoordinate2D) -> Void) {
        self.region = region
        self.onSearch = onSearch
        self.completer = MKLocalSearchCompleter()

        super.init()

        completer.delegate = self
        completer.region = region
    }

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
                NSLog("[SearchViewModel] Search failed with error \(error)")
                return
            }

            guard let response = response,
                  let searchItemCoordinate = response.mapItems.first?.placemark.location?.coordinate else {
                NSLog("[SearchViewModel] Search response invalid")
                return
            }

            self?.onSearch(searchItemCoordinate)
        }
    }
}

extension SearchViewModel: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        NSLog("[SearchViewModel] Search completer did fail with error \(error)")
    }
}
