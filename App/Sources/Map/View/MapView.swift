import MapKit
import SwiftUI
import ClusterMapSwiftUI

struct MapView: View {
    @StateObject private var viewModel: MapViewModel

    init(analyticsManager: AnalyticsManager = .init(), onShowAlert: @escaping (_ alert: Alert) -> Void) {
        self._viewModel = .init(wrappedValue: .init(analyticsManager: analyticsManager,
                                                    onShowAlert: onShowAlert))
    }

    @State private var searchText: String = ""
    @FocusState var isFocused: Bool

    var body: some View {
        map
            .overlay(alignment: .topLeading) {
                search
            }
            .overlay(alignment: .bottomTrailing) {
                FollowModeButton(trackingMode: $viewModel.trackingMode, locationPermissionStatus: $viewModel.locationPermissionStatus, errorMessage: $viewModel.errorMessage) {
                    viewModel.showLocationPermissionAlert()
                }
                .padding([.bottom, .trailing])
            }
            .ignoresSafeArea(.keyboard) // Prevents view from moving upward when keyboard in search view appears
            .onAppear {
                viewModel.onAppear()
            }
            .accessibilityElement(children: .ignore)
            .accessibilityIdentifier(AccessibilityIdentifiers.mapView)
    }

    private func mapItem(for annotation: GasStationAnnotation) -> some MapAnnotationProtocol {
        switch annotation.style {
        case .single(let gasStation):
            GasStationMapAnnotationProtocol(
                MapAnnotation(coordinate: annotation.coordinate, anchorPoint: CGPoint(x: 0.5, y: 1.0)) {
                    MapAnnotationView(viewModel: .init(gasStation: gasStation), isTopAnnotationViewHidden: $viewModel.isTopAnnotationHidden)
                        .id(annotation.id)
                }
            )
        case .cluster(let count):
            GasStationMapAnnotationProtocol(
                MapAnnotation(coordinate: annotation.coordinate, anchorPoint: CGPoint(x: 0.5, y: 1.0)) {
                    MapClusterAnnotationView(count: count)
                        .id(annotation.id)
            })
        }
    }

    @ViewBuilder
    private var map: some View {
        Map(coordinateRegion: $viewModel.region,
            interactionModes: .all,
            showsUserLocation: true,
            userTrackingMode: $viewModel.trackingMode,
            annotationItems: viewModel.annotations,
            annotationContent: mapItem(for:))
            .accentColor(.primaryTint)
            .onReceive(viewModel.$region.debounce(for: .milliseconds(500), scheduler: DispatchQueue.main), perform: { newRegion in
                viewModel.didChangeRegion(newRegion)
            })
            .edgesIgnoringSafeArea(.top)
            .onTapGesture {
                viewModel.isSearchViewPresented = false
            }
            .onChange(of: viewModel.region) { _ in
                viewModel.isSearchViewPresented = false // set this here because of the debounce in onReceive
            }
            .onAppear {
                viewModel.bind()
            }
            .readSize(onChange: { newValue in
                viewModel.mapSize = newValue
            })
    }

    // MARK: - Search

    @ViewBuilder
    private var search: some View {
        HStack {
            if !viewModel.isSearchViewPresented {
                searchButton
            } else {
                VStack {
                    HStack {
                        searchIcon
                        searchField
                        cancelButton
                    }
                    resultList
                }
            }
        }
        .background(Color.genericWhite)
        .cornerRadius(viewModel.isSearchViewPresented ? .cornerRadius : 60)
        .padding()
        .addShadow()
    }

    @ViewBuilder
    private var searchButton: some View {
        Button(action: {
            viewModel.isSearchViewPresented = true
        }, label: {
            searchIcon
        })
    }

    @ViewBuilder
    private var searchIcon: some View {
        ZStack {
            Circle()
                .frame(width: 50, height: 50)
                .foregroundStyle(Color.genericWhite)
            Image(.mapSearchIcon)
                .frame(width: 32, height: 32)
        }
    }

    @ViewBuilder
    private var searchField: some View {
        HStack {
            TextField(L10n.searchTitle, text: $searchText)
                .font(.system(size: 20))
                .foregroundStyle(Color.genericBlack)
                .tint(Color.genericBlack)
                .padding(.trailing, .paddingXXS)
                .submitLabel(.search)
                .focused($isFocused)
                .onAppear {
                    self.isFocused = true
                }
                .onChange(of: searchText) { newText in
                    viewModel.completeSearch(for: newText)
                }
                .onSubmit {
                    guard !searchText.isEmpty else { return }
                    viewModel.search(for: searchText)
                }
        }
        .frame(maxWidth: .infinity, minHeight: 50)
    }

    @ViewBuilder
    private var cancelButton: some View {
        Button(action: {
            if searchText.isEmpty {
                viewModel.isSearchViewPresented = false
            } else {
                searchText = ""
            }
        }, label: {
            Image(.mapCancel)
                .frame(width: 24, height: 24)
        })
        .padding(.trailing, .paddingXS)
        .padding(.leading, .paddingXXXS)
    }

    @ViewBuilder
    private var resultList: some View {
        if !viewModel.searchResults.isEmpty && !searchText.isEmpty {
            ForEach(viewModel.searchResults, id: \.self) { searchResult in
                Button(action: {
                    viewModel.search(for: searchResult)
                }, label: {
                    HStack {
                        VStack(alignment: .leading, spacing: .paddingXXXS) {
                            Divider()
                                .padding(.bottom, .paddingXXXS)
                            TextLabel(searchResult.title, alignment: .leading)
                                .font(.system(size: 16, weight: .bold))
                            TextLabel(searchResult.subtitle, textColor: .genericGrey, alignment: .leading)
                                .font(.system(size: 12))
                        }
                        Spacer()
                    }
                    .padding(.horizontal, .paddingXS)
                })
            }
            .padding(.bottom, .paddingXXS)
        }
    }
}
