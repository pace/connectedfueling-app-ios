// Copyright © 2023 PACE Telematics GmbH. All rights reserved.

import MapKit
import SwiftUI

struct IdentifiablePlace: Identifiable {
    let id: UUID
    let coordinate: CLLocationCoordinate2D

    init(id: UUID = UUID(), coordinate: CLLocationCoordinate2D?) {
        self.id = id
        self.coordinate = coordinate ?? .init()
    }
}

struct GasStationDetailView: View {
    @ObservedObject private var viewModel: GasStationDetailViewModel

    init(viewModel: GasStationDetailViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        content
            .background(BackgroundContainer())
            .sheet(item: $viewModel.fuelingUrlString) { fuelingUrlString in
                AppView(urlString: fuelingUrlString, isModalInPresentation: true)
            }
    }

    @ViewBuilder
    private var content: some View {
        VStack {
            ScrollView {
                VStack(spacing: .paddingL) {
                    map
                    info
                    if !viewModel.priceInfos.isEmpty {
                        prices
                    }
                    openingHours
                }
            }
            button
        }
        .padding(.paddingM)
    }

    @ViewBuilder
    private var map: some View {
        Map(coordinateRegion: .constant(MKCoordinateRegion(center: viewModel.location,
                                                           span: MKCoordinateSpan(latitudeDelta: Constants.GasStationDetail.mapDelta,
                                                                                  longitudeDelta: Constants.GasStationDetail.mapDelta))),
            annotationItems: [IdentifiablePlace(coordinate: viewModel.location)]) { place in
            MapAnnotation(coordinate: place.coordinate) {
                MapGasStationBottomMarkerView()
            }
        }
            .allowsHitTesting(false)
            .cornerRadius(15)
            .frame(height: 120)
    }

    @ViewBuilder
    private var info: some View {
        HStack {
            VStack(spacing: .paddingXS) {
                HStack {
                    TextLabel(viewModel.gasStation.name)
                        .font(.system(size: 20, weight: .bold))
                    Spacer()
                }
                address
                HStack {
                    DistanceTagView(viewModel.distanceStyle)
                    Spacer()
                }
                if viewModel.isClosed {
                    HStack {
                        Image(systemName: "exclamationmark.circle")
                            .frame(width: 24, height: 24)
                            .foregroundColor(Color.genericRed)
                        TextLabel(L10n.gasStationClosedHint, textColor: Color.genericRed)
                            .font(.system(size: 14, weight: .bold))
                        Spacer()
                    }
                }
            }
            Spacer()
        }
    }

    @ViewBuilder
    private var address: some View {
        VStack {
            ForEach(viewModel.gasStation.addressLines) { line in
                HStack {
                    TextLabel(line)
                        .font(.system(size: 16))
                    Spacer()
                }
            }
        }
    }

    @ViewBuilder
    private var prices: some View {
        VStack(spacing: .paddingXS) {
            HStack {
                TextLabel(L10n.gasStationFuelPricesTitle)
                    .font(.system(size: 16, weight: .bold))
                Spacer()
            }
            PriceCardStack(viewModel.priceInfos)
            if let lastUpdated = viewModel.lastUpdated {
                HStack {
                    TextLabel(L10n.gasStationLastUpdated(lastUpdated))
                        .font(.system(size: 12))
                    Spacer()
                }
            }
        }
    }

    @ViewBuilder
    private var openingHours: some View {
        VStack(spacing: .paddingXS) {
                HStack {
                    TextLabel(L10n.gasStationOpeningHoursTitle)
                        .font(.system(size: 16, weight: .bold))
                    Spacer()
                }
                if viewModel.openingHourRows.isEmpty {
                    HStack {
                        TextLabel(L10n.gasStationOpeningHoursNotAvailable)
                            .font(.system(size: 12))
                        Spacer()
                    }
                } else {
                    openingHoursRows
                    HStack {
                        TextLabel(L10n.gasStationOpeningHoursHint)
                            .font(.system(size: 12))
                        Spacer()
                    }
                }
            }
            Spacer()
    }

    @ViewBuilder
    private var openingHoursRows: some View {
        VStack {
            ForEach(viewModel.openingHourRows, id: \.self) { row in
                OpeningHoursRow(leftText: row.days, rightText: row.hours)
            }
        }
    }

    @ViewBuilder
    private var button: some View {
        ActionButton(title: viewModel.actionTitle,
                     style: viewModel.gasStation.isConnectedFuelingEnabled ? .primary : .ternary) {
            viewModel.didTapActionButton()
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Many prices

#Preview {
    GasStationDetailView(viewModel: .init(gasStation: .init(id: "id",
                                                            name: "Tanke",
                                                            addressLines: ["Address line 1", "Address line 2"],
                                                            distanceInKilometers: 1.234,
                                                            location: .init(latitude: 49.012233, longitude: 8.427348),
                                                            paymentMethods: [],
                                                            isConnectedFuelingEnabled: true,
                                                            fuelType: .cheapestDiesel,
                                                            fuelPrice: .init(value: 1.998, currency: "eur", format: "d.dds"),
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
                                                            openingHours: [
                                                                .init(days: [.monday, .tuesday],
                                                                      hours: [.init(from: "8", to: "17")],
                                                                      rule: .open),
                                                                .init(days: [.wednesday, .thursday, .friday],
                                                                      hours: [.init(from: "9", to: "19")],
                                                                      rule: .open),
                                                                .init(days: [.saturday, .sunday],
                                                                      hours: [.init(from: "10", to: "16")],
                                                                      rule: .open)
                                                            ])))
}

// MARK: - Near & 2 prices

#Preview {
    GasStationDetailView(viewModel: .init(gasStation: .init(id: "id2",
                                                            name: "Tanke Danke",
                                                            addressLines: ["Address line 1", "Address line 2"],
                                                            distanceInKilometers: 0.234,
                                                            location: .init(latitude: 49.012233, longitude: 8.427348),
                                                            paymentMethods: [],
                                                            isConnectedFuelingEnabled: true,
                                                            fuelType: .cheapestDiesel,
                                                            fuelPrice: .init(value: 1.998, currency: "eur", format: "d.dds"),
                                                            prices: [
                                                                .init(fuelType: .ron95e5,
                                                                      fuelPrice: .init(value: 1.789,
                                                                                       currency: "eur",
                                                                                       format: "d.dds")),
                                                                .init(fuelType: .ron95e10,
                                                                      fuelPrice: .init(value: 1.339,
                                                                                       currency: "eur",
                                                                                       format: "d.dds"))
                                                            ],
                                                            lastUpdated: Date(),
                                                            openingHours: [
                                                                .init(days: [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday],
                                                                      hours: [.init(from: "3", to: "22")],
                                                                      rule: .open),
                                                            ])))
}

// MARK: - No prices & closed

#Preview {
    GasStationDetailView(viewModel: .init(gasStation: .init(id: "id3",
                                                            name: "Tanke Danke",
                                                            addressLines: ["Address line 1", "Address line 2"],
                                                            distanceInKilometers: 0.234,
                                                            location: .init(latitude: 49.012233, longitude: 8.427348),
                                                            paymentMethods: [],
                                                            isConnectedFuelingEnabled: true,
                                                            fuelType: .cheapestDiesel,
                                                            fuelPrice: .init(value: 1.998, currency: "eur", format: "d.dds"),
                                                            prices: [],
                                                            lastUpdated: Date(),
                                                            openingHours: [
                                                                .init(days: [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday],
                                                                      hours: [.init(from: "3", to: "22")],
                                                                      rule: .closed)
                                                            ])))
}

// MARK: - No prices & No opening hours

#Preview {
    GasStationDetailView(viewModel: .init(gasStation: .init(id: "id4",
                                                            name: "Tanke Danke",
                                                            addressLines: ["Address line 1", "Address line 2"],
                                                            distanceInKilometers: 0.234,
                                                            location: .init(latitude: 49.012233, longitude: 8.427348),
                                                            paymentMethods: [],
                                                            isConnectedFuelingEnabled: true,
                                                            fuelType: .cheapestDiesel,
                                                            fuelPrice: .init(value: 1.998, currency: "eur", format: "d.dds"),
                                                            prices: [],
                                                            lastUpdated: Date(),
                                                            openingHours: [])))
}
