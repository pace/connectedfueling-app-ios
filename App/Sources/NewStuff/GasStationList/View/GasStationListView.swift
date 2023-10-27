// Copyright © 2023 PACE Telematics GmbH. All rights reserved.

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
                    GasStationListItemView(viewModel: .init(gasStation: gasStation))
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
        LoadingView(title: L10n.Dashboard.LoadingView.title,
                    description: L10n.Dashboard.LoadingView.description)
    }
}

// MARK: - Loading state
#Preview {
    AppNavigationView {
        GasStationListView(viewModel: .init())
            .addNavigationBar()
    }
}

// MARK: - Empty state
#Preview {
    AppNavigationView {
        GasStationListView(viewModel: .init(sections: []))
            .addNavigationBar()
    }
}

// MARK: - Populated state
#Preview {
    AppNavigationView {
        GasStationListView(viewModel: .init(sections: [
            .nearest(
                .init(id: "id",
                      name: "MobyPay 3435",
                      addressLines: [
                        "Gerwigstraße 1",
                        "76131 Karlsruhe"
                      ],
                      distanceInKilometers: 0.134,
                      location: nil,
                      paymentMethods: [],
                      isConnectedFuelingEnabled: true,
                      fuelType: .init(rawValue: "ron95e5"),
                      fuelPrice: .init(value: 1.38, currency: "EUR", format: "d.dds"))
            ),
            .other([
                .init(id: "id-1",
                      name: "MobyPay 3436",
                      addressLines: [
                        "Gerwigstraße 2",
                        "76131 Karlsruhe"
                      ],
                      distanceInKilometers: 0.234,
                      location: nil,
                      paymentMethods: [],
                      isConnectedFuelingEnabled: true,
                      fuelType: .init(rawValue: "ron95e5"),
                      fuelPrice: .init(value: 1.389, currency: "EUR", format: "d.dds")),
                .init(id: "id-2",
                      name: "MobyPay 3437",
                      addressLines: [
                        "Gerwigstraße 3",
                        "76131 Karlsruhe"
                      ],
                      distanceInKilometers: 0.334,
                      location: nil,
                      paymentMethods: [],
                      isConnectedFuelingEnabled: false,
                      fuelType: .init(rawValue: "ron95e5"),
                      fuelPrice: .init(value: 1.38, currency: "EUR", format: nil))
            ])
        ]))
        .addNavigationBar()
    }
}
