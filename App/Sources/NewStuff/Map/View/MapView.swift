import MapKit
import SwiftUI

struct MapView: View {
    @StateObject private var viewModel: MapViewModel = .init()

    var body: some View {
        map
            .overlay(alignment: .topLeading) {
                MapButton(icon: .constant(.mapSearchIcon)) {
                    viewModel.isSearchViewPresented = true
                }
                .padding([.top, .leading], .paddingM)
            }
            .overlay(alignment: .bottomTrailing) {
                FollowModeButton(trackingMode: $viewModel.trackingMode)
                    .padding([.bottom, .trailing], .paddingM)
            }
            .sheet(isPresented: $viewModel.isSearchViewPresented) {
                SearchView(viewModel: .init(region: viewModel.region, onSearch: { searchLocation in
                    viewModel.didTriggerSearch(at: searchLocation)
                }))
            }
            .ignoresSafeArea(.keyboard) // Prevents view from moving upward when keyboard in search view appears
    }

    @ViewBuilder
    private var map: some View {
        Map(coordinateRegion: $viewModel.region,
            showsUserLocation: true,
            userTrackingMode: $viewModel.trackingMode,
            annotationItems: viewModel.annotations) { annotation in
            MapAnnotation(coordinate: annotation.coordinate) {
                MapAnnotationView(viewModel: .init(annotation: annotation), isTopAnnotationViewHidden: $viewModel.isTopAnnotationHidden)
            }
        }
            .onReceive(viewModel.$region.debounce(for: .milliseconds(500), scheduler: RunLoop.main), perform: { newRegion in
                viewModel.didChangeRegion(newRegion)
            })
            .edgesIgnoringSafeArea(.top)
    }
}
