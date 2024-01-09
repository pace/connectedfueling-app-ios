import SwiftUI

struct GasStationListView: View {
    @ObservedObject private var viewModel: GasStationListViewModel

    init(viewModel: GasStationListViewModel = .init()) {
        self.viewModel = viewModel
    }

    var body: some View {
        content
            .alert(item: $viewModel.alert) { alert in
                alert
            }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.style {
        case .primary:
            viewContent
                .edgesIgnoringSafeArea(.top)

        case .secondary:
            viewContent
        }
    }

    @ViewBuilder
    private var viewContent: some View {
        VStack(spacing: 0) {
            headerContent
                .padding(.bottom, 10)
            if let stations = viewModel.stations {
                if stations.isEmpty {
                    Spacer()
                    emptyView
                    Spacer()
                } else {
                    list(of: stations)
                }
            } else {
                Spacer()
                loadingView
                    .onAppear {
                        viewModel.viewWillAppear()
                    }
                Spacer()
            }
        }
    }

    @ViewBuilder
    private var headerContent: some View {
        if viewModel.style == .primary {
            Image(.gasStationListPrimaryHeaderIcon)
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: 200, alignment: .bottom)
        } else {
            Spacer()
                .frame(height: 2)
        }
    }

    @ViewBuilder
    private var emptyView: some View {
        GasStationListEmptyView()
    }

    @ViewBuilder
    private func list(of stations: [GasStation]) -> some View {
        List {
            ForEach(stations, id: \.self) { gasStation in
                GasStationListItemView(viewModel: .init(gasStation: gasStation))
            }
            .listRowInsets(.init(top: 0, leading: 25, bottom: 10, trailing: 25))
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
        }
        .listStyle(.plain)
    }

    private var loadingView: some View {
        LoadingSpinner()
    }
}

// MARK: - Loading state
#Preview {
    AppNavigationView {
        switch ConfigurationManager.configuration.gasStationListStyle {
        case .primary:
            GasStationListView()

        case .secondary:
            GasStationListView()
                .addNavigationBar(style: .centeredIcon(icon: .secondaryHeaderIcon))
        }
    }
}

// MARK: - Empty state
#Preview {
    AppNavigationView {
        switch ConfigurationManager.configuration.gasStationListStyle {
        case .primary:
            GasStationListView(viewModel: .init(stations: []))

        case .secondary:
            GasStationListView(viewModel: .init(stations: []))
                .addNavigationBar(style: .centeredIcon(icon: .secondaryHeaderIcon))
        }
    }
}

// MARK: - Populated state
#Preview {
    AppNavigationView {
        switch ConfigurationManager.configuration.gasStationListStyle {
        case .primary:
            GasStationListView(viewModel: .init(stations: [
                    .init(id: "id",
                          name: "MobyPay 3435",
                          addressLines: [
                            "Gerwigstraße 1",
                            "76131 Karlsruhe"
                          ],
                          distanceInKilometers: 0.134,
                          location: .init(latitude: 49.013573, longitude: 8.419447),
                          paymentMethods: [],
                          isConnectedFuelingEnabled: true,
                          prices: [
                            .init(value: 1.889,
                                  fuelType: .diesel,
                                  currency: "EUR",
                                  format: "d.dds"),
                            .init(value: 1.789,
                                  fuelType: .ron95e5,
                                  currency: "EUR",
                                  format: "d.dds")
                          ],
                          lastUpdated: Date(),
                          openingHours: [.init(days: [.monday, .tuesday],
                                               hours: [.init(from: "8", to: "17")],
                                               rule: .open),
                                         .init(days: [.wednesday, .thursday, .friday],
                                               hours: [.init(from: "9", to: "19")],
                                               rule: .open),
                                         .init(days: [.saturday, .sunday],
                                               hours: [.init(from: "10", to: "16")],
                                               rule: .open)]),
                    .init(id: "id3",
                          name: "Tanke Danke",
                          addressLines: ["Address line 1", "Address line 2"],
                          distanceInKilometers: 0.234,
                          location: .init(latitude: 49.012233, longitude: 8.427348),
                          paymentMethods: [],
                          isConnectedFuelingEnabled: false,
                          prices: [
                            .init(value: 1.789,
                                  fuelType: .ron95e5,
                                  currency: "EUR",
                                  format: "d.dds"),
                            .init(value: 1.339,
                                  fuelType: .ron95e10,
                                  currency: "EUR",
                                  format: "d.dds")
                          ],
                          lastUpdated: Date(),
                          openingHours: [
                            .init(days: [.monday, .tuesday],
                                  hours: [.init(from: "8", to: "15:30")],
                                  rule: .open),
                            .init(days: [.wednesday, .thursday, .friday],
                                  hours: [.init(from: "9", to: "19")],
                                  rule: .open),
                            .init(days: [.saturday, .sunday],
                                  hours: [.init(from: "10", to: "16")],
                                  rule: .open)
                          ]),
                    .init(id: "id2",
                          name: "Tanke Danke",
                          addressLines: ["Address line 1", "Address line 2"],
                          distanceInKilometers: 0.234,
                          location: .init(latitude: 49.012233, longitude: 8.427348),
                          paymentMethods: [],
                          isConnectedFuelingEnabled: true,
                          prices: [
                            .init(value: 1.789,
                                  fuelType: .ron95e5,
                                  currency: "EUR",
                                  format: "d.dds"),
                            .init(value: 1.339,
                                  fuelType: .ron95e10,
                                  currency: "EUR",
                                  format: "d.dds")
                          ],
                          lastUpdated: Date(),
                          openingHours: [
                            .init(days: [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday],
                                  hours: [.init(from: "3", to: "22")],
                                  rule: .open),
                          ]),
                    .init(id: "id-1",
                          name: "MobyPay 3436",
                          addressLines: [
                            "Gerwigstraße 2",
                            "76131 Karlsruhe"
                          ],
                          distanceInKilometers: 0.234,
                          location: .init(latitude: 49.013573, longitude: 8.419447),
                          paymentMethods: [],
                          isConnectedFuelingEnabled: true,
                          prices: [
                            .init(value: 1.889,
                                  fuelType: .diesel,
                                  currency: "EUR",
                                  format: "d.dds"),
                            .init(value: 1.789,
                                  fuelType: .ron95e5,
                                  currency: "EUR",
                                  format: "d.dds"),
                            .init(value: 1.789,
                                  fuelType: .ron98e5,
                                  currency: "EUR",
                                  format: "d.dds"),
                            .init(value: 1.759,
                                  fuelType: .ron100,
                                  currency: "EUR",
                                  format: "d.dds"),
                            .init(value: 1.789,
                                  fuelType: .dieselGtl,
                                  currency: "EUR",
                                  format: "d.dds"),
                            .init(value: 1.989,
                                  fuelType: .premiumPetrol,
                                  currency: "EUR",
                                  format: "d.dds"),
                            .init(value: 1.339,
                                  fuelType: .ron95e10,
                                  currency: "EUR",
                                  format: "d.dds")
                          ],
                          lastUpdated: Date(),
                          openingHours: [.init(days: [.monday, .tuesday],
                                               hours: [.init(from: "8", to: "17")],
                                               rule: .open),
                                         .init(days: [.wednesday, .thursday, .friday],
                                               hours: [.init(from: "9", to: "19")],
                                               rule: .open),
                                         .init(days: [.saturday, .sunday],
                                               hours: [.init(from: "10", to: "16")],
                                               rule: .open)]),
                    .init(id: "id-2",
                          name: "MobyPay 3437",
                          addressLines: [
                            "Gerwigstraße 3",
                            "76131 Karlsruhe"
                          ],
                          distanceInKilometers: 0.334,
                          location: .init(latitude: 49.013573, longitude: 8.419447),
                          paymentMethods: [],
                          isConnectedFuelingEnabled: false,
                          prices: [],
                          lastUpdated: Date(),
                          openingHours: [])
            ]))

        case .secondary:
            GasStationListView(viewModel: .init(stations: [
                    .init(id: "id",
                          name: "MobyPay 3435",
                          addressLines: [
                            "Gerwigstraße 1",
                            "76131 Karlsruhe"
                          ],
                          distanceInKilometers: 0.134,
                          location: .init(latitude: 49.013573, longitude: 8.419447),
                          paymentMethods: [],
                          isConnectedFuelingEnabled: true,
                          prices: [
                            .init(value: 1.889,
                                  fuelType: .diesel,
                                  currency: "EUR",
                                  format: "d.dds"),
                            .init(value: 1.789,
                                  fuelType: .ron95e5,
                                  currency: "EUR",
                                  format: "d.dds")
                          ],
                          lastUpdated: Date(),
                          openingHours: [.init(days: [.monday, .tuesday],
                                               hours: [.init(from: "8", to: "17")],
                                               rule: .open),
                                         .init(days: [.wednesday, .thursday, .friday],
                                               hours: [.init(from: "9", to: "19")],
                                               rule: .open),
                                         .init(days: [.saturday, .sunday],
                                               hours: [.init(from: "10", to: "16")],
                                               rule: .open)]),
                    .init(id: "id-1",
                          name: "MobyPay 3436",
                          addressLines: [
                            "Gerwigstraße 2",
                            "76131 Karlsruhe"
                          ],
                          distanceInKilometers: 0.234,
                          location: .init(latitude: 49.013573, longitude: 8.419447),
                          paymentMethods: [],
                          isConnectedFuelingEnabled: true,
                          prices: [
                            .init(value: 1.889,
                                  fuelType: .diesel,
                                  currency: "EUR",
                                  format: "d.dds"),
                            .init(value: 1.789,
                                  fuelType: .ron95e5,
                                  currency: "EUR",
                                  format: "d.dds"),
                            .init(value: 1.789,
                                  fuelType: .ron98e5,
                                  currency: "EUR",
                                  format: "d.dds"),
                            .init(value: 1.759,
                                  fuelType: .ron100,
                                  currency: "EUR",
                                  format: "d.dds"),
                            .init(value: 1.789,
                                  fuelType: .dieselGtl,
                                  currency: "EUR",
                                  format: "d.dds"),
                            .init(value: 1.989,
                                  fuelType: .premiumPetrol,
                                  currency: "EUR",
                                  format: "d.dds"),
                            .init(value: 1.339,
                                  fuelType: .ron95e10,
                                  currency: "EUR",
                                  format: "d.dds")
                          ],
                          lastUpdated: Date(),
                          openingHours: [.init(days: [.monday, .tuesday],
                                               hours: [.init(from: "8", to: "17")],
                                               rule: .open),
                                         .init(days: [.wednesday, .thursday, .friday],
                                               hours: [.init(from: "9", to: "19")],
                                               rule: .open),
                                         .init(days: [.saturday, .sunday],
                                               hours: [.init(from: "10", to: "16")],
                                               rule: .open)]),
                    .init(id: "id-2",
                          name: "MobyPay 3437",
                          addressLines: [
                            "Gerwigstraße 3",
                            "76131 Karlsruhe"
                          ],
                          distanceInKilometers: 0.334,
                          location: .init(latitude: 49.013573, longitude: 8.419447),
                          paymentMethods: [],
                          isConnectedFuelingEnabled: false,
                          prices: [],
                          lastUpdated: Date(),
                          openingHours: [])
            ]))
            .addNavigationBar(style: .centeredIcon(icon: .secondaryHeaderIcon))
        }
    }
}
