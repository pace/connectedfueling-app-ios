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
        if let sections = viewModel.sections {
            if sections.isEmpty {
                emptyView
            } else {
                list(of: sections)
            }
        } else {
            loadingView
                .onAppear {
                    viewModel.viewWillAppear()
                }
        }
    }

    @ViewBuilder
    private var emptyView: some View {
        GasStationListEmptyView()
    }

    @ViewBuilder
    private func list(of sections: [GasStationListSection]) -> some View {
        List(sections, id: \.self) { section in
            Section(header: section.header) {
                ForEach(section.gasStations, id: \.self) { gasStation in
                    NavigationLink(destination: GasStationDetailView(viewModel: .init(gasStation: gasStation))) {
                        GasStationListItemView(viewModel: .init(gasStation: gasStation))
                    }
                }
            }
            .listRowInsets(.init(top: 0, leading: 25, bottom: 10, trailing: 25))
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .refreshable {
            viewModel.reloadCofuStations()
        }
    }

    @ViewBuilder
    private func sectionHeader(title: String) -> some View {
        TextLabel(title)
            .font(.system(size: 20, weight: .semibold))
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
            GasStationListView(viewModel: .init(sections: []))

        case .secondary:
            GasStationListView(viewModel: .init(sections: []))
                .addNavigationBar(style: .centeredIcon(icon: .secondaryHeaderIcon))
        }
    }
}

// MARK: - Populated state
#Preview {
    AppNavigationView {
        switch ConfigurationManager.configuration.gasStationListStyle {
        case .primary:
            GasStationListView(viewModel: .init(sections: [
                .nearest(
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
                          fuelType: .init(rawValue: "ron95e5"),
                          fuelPrice: .init(value: 1.38, currency: "EUR", format: "d.dds"),
                          prices: [
                            .init(fuelType: .diesel,
                                  fuelPrice: .init(value: 1.889,
                                                   currency: "eur",
                                                   format: "d.dds")),
                            .init(fuelType: .ron95e5,
                                  fuelPrice: .init(value: 1.789,
                                                   currency: "eur",
                                                   format: "d.dds"))
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
                                               rule: .open)])
                ),
                .other([
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
                          fuelType: .init(rawValue: "ron95e5"),
                          fuelPrice: .init(value: 1.389, currency: "EUR", format: "d.dds"),
                          prices: [
                            .init(fuelType: .diesel,
                                  fuelPrice: .init(value: 1.889,
                                                   currency: "eur",
                                                   format: "d.dds")),
                            .init(fuelType: .ron95e5,
                                  fuelPrice: .init(value: 1.789,
                                                   currency: "eur",
                                                   format: "d.dds")),
                            .init(fuelType: .ron98e5,
                                  fuelPrice: .init(value: 1.789,
                                                   currency: "eur",
                                                   format: "d.dds")),
                            .init(fuelType: .ron100,
                                  fuelPrice: .init(value: 1.759,
                                                   currency: "eur",
                                                   format: "d.dds")),
                            .init(fuelType: .dieselGtl,
                                  fuelPrice: .init(value: 1.789,
                                                   currency: "eur",
                                                   format: "d.dds")),
                            .init(fuelType: .premiumPetrol,
                                  fuelPrice: .init(value: 1.989,
                                                   currency: "eur",
                                                   format: "d.dds")),
                            .init(fuelType: .ron95e10,
                                  fuelPrice: .init(value: 1.339,
                                                   currency: "eur",
                                                   format: "d.dds"))
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
                          fuelType: .init(rawValue: "ron95e5"),
                          fuelPrice: .init(value: 1.38, currency: "EUR", format: nil),
                          prices: [],
                          lastUpdated: Date(),
                          openingHours: [])
                ])
            ]))
        
        case .secondary:
            GasStationListView(viewModel: .init(sections: [
                .nearest(
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
                          fuelType: .init(rawValue: "ron95e5"),
                          fuelPrice: .init(value: 1.38, currency: "EUR", format: "d.dds"),
                          prices: [
                            .init(fuelType: .diesel,
                                  fuelPrice: .init(value: 1.889,
                                                   currency: "eur",
                                                   format: "d.dds")),
                            .init(fuelType: .ron95e5,
                                  fuelPrice: .init(value: 1.789,
                                                   currency: "eur",
                                                   format: "d.dds"))
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
                                               rule: .open)])
                ),
                .other([
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
                          fuelType: .init(rawValue: "ron95e5"),
                          fuelPrice: .init(value: 1.389, currency: "EUR", format: "d.dds"),
                          prices: [
                            .init(fuelType: .diesel,
                                  fuelPrice: .init(value: 1.889,
                                                   currency: "eur",
                                                   format: "d.dds")),
                            .init(fuelType: .ron95e5,
                                  fuelPrice: .init(value: 1.789,
                                                   currency: "eur",
                                                   format: "d.dds")),
                            .init(fuelType: .ron98e5,
                                  fuelPrice: .init(value: 1.789,
                                                   currency: "eur",
                                                   format: "d.dds")),
                            .init(fuelType: .ron100,
                                  fuelPrice: .init(value: 1.759,
                                                   currency: "eur",
                                                   format: "d.dds")),
                            .init(fuelType: .dieselGtl,
                                  fuelPrice: .init(value: 1.789,
                                                   currency: "eur",
                                                   format: "d.dds")),
                            .init(fuelType: .premiumPetrol,
                                  fuelPrice: .init(value: 1.989,
                                                   currency: "eur",
                                                   format: "d.dds")),
                            .init(fuelType: .ron95e10,
                                  fuelPrice: .init(value: 1.339,
                                                   currency: "eur",
                                                   format: "d.dds"))
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
                          fuelType: .init(rawValue: "ron95e5"),
                          fuelPrice: .init(value: 1.38, currency: "EUR", format: nil),
                          prices: [],
                          lastUpdated: Date(),
                          openingHours: [])
                ])
            ]))
            .addNavigationBar(style: .centeredIcon(icon: .secondaryHeaderIcon))
        }
    }
}
