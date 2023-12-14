import SwiftUI

struct GasStationListItemView: View {
    @ObservedObject private var viewModel: GasStationListItemViewModel

    init(viewModel: GasStationListItemViewModel) {
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
        VStack(alignment: .leading, spacing: 0) {
            ZStack {
                info
                NavigationLink(destination: GasStationDetailView(viewModel: .init(gasStation: viewModel.gasStation)) ) {
                    EmptyView()
                }
                .opacity(0)
            }
            button
                .padding(.horizontal, .paddingS)
            closeDisclaimer
                .padding(.horizontal, .paddingM)
        }
    }

    @ViewBuilder
    private var info: some View {
        VStack {
            if viewModel.isHighlighted {
                ZStack {
                    Color.genericGreen
                        .frame(height: 30)
                    TextLabel(L10n.commonPayHereNow, textColor: .genericWhite)
                        .font(.system(size: 14, weight: .bold))
                }
                .padding(.bottom, .paddingXS)
                .cornerRadius(12, corners: [.topLeft, .topRight])
            } else {
                Spacer()
                    .frame(height: .paddingM)
            }
            VStack {
                HStack(alignment: .center, spacing: 0) {
                    details
                    Spacer()
                    priceLabel
                }
                HStack {
                    DistanceTagView(viewModel.distanceStyle)
                    Spacer()
                }
                .padding(.bottom, .paddingXS)
            }
            .padding(.horizontal, .paddingS)
        }
    }

    @ViewBuilder
    private var button: some View {
        ActionButton(title: viewModel.actionTitle,
                     style: viewModel.gasStation.isConnectedFuelingEnabled ? .primary : .secondary) {
            // Since buttons that are included in a list behave differently
            // than intended, e.g not highlighted when tapped and the List treats
            // the entire list item as the button,
            // set the button' style to `plain`
            viewModel.didTapActionButton()
        }
                     .buttonStyle(.plain)
                     .padding(.bottom, viewModel.isClosingSoon ? .paddingXXS : .paddingS)
    }

    @ViewBuilder
    private var closeDisclaimer: some View {
        if viewModel.isClosingSoon, let closingTimeToday = viewModel.closingTimeToday {
            HStack {
                Spacer()
                Image(.errorIcon)
                    .frame(width: 24, height: 24)
                    .foregroundColor(Color.genericRed)
                TextLabel(L10n.gasstationClosesIn(closingTimeToday), textColor: Color.genericRed)
                    .font(.system(size: 14, weight: .bold))
                Spacer()
            }
            .padding(.bottom, .paddingXS)
        } else if viewModel.isClosed {
            HStack {
                Spacer()
                Image(.errorIcon)
                    .frame(width: 24, height: 24)
                    .foregroundColor(Color.genericRed)
                TextLabel(L10n.gasStationClosedHint, textColor: Color.genericRed)
                    .font(.system(size: 14, weight: .bold))
                Spacer()
            }
            .padding(.bottom, .paddingXS)
        }
    }

    @ViewBuilder
    private var details: some View {
        VStack(alignment: .leading, spacing: 0) {
            TextLabel(viewModel.gasStation.name, alignment: .leading)
                .font(.system(size: 20, weight: .bold))
                .padding(.bottom, .paddingXXS)
            ForEach(viewModel.gasStation.addressLines, id: \.self) { addressLine in
                TextLabel(addressLine)
                    .font(.system(size: 16, weight: .medium))
            }
        }
    }

    @ViewBuilder
    private var priceLabel: some View {
        if viewModel.priceAvailable {
            PriceCardView(title: viewModel.formattedFuelType,
                          priceText: viewModel.formattedPrice)
        }
    }
}

#Preview {
    VStack(spacing: .paddingM) {
        GasStationListItemView(viewModel: .init(gasStation: .init(id: "id",
                                                                  name: "MobyPay 3435",
                                                                  addressLines: [
                                                                    "Gerwigstraße 2",
                                                                    "76131 Karlsruhe"
                                                                  ],
                                                                  distanceInKilometers: 0.234,
                                                                  location: .init(latitude: 0, longitude: 0),
                                                                  paymentMethods: [],
                                                                  isConnectedFuelingEnabled: true,
                                                                  prices: [
                                                                    .init(value: 1.79,
                                                                          fuelType: .ron95e5,
                                                                          currency: "EUR",
                                                                          format: "d.dds")
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
        GasStationListItemView(viewModel: .init(gasStation: .init(id: "id",
                                                                  name: "MobyPay 3435",
                                                                  addressLines: [
                                                                    "Gerwigstraße 2",
                                                                    "76131 Karlsruhe"
                                                                  ],
                                                                  distanceInKilometers: 0.234,
                                                                  location: .init(latitude: 0, longitude: 0),
                                                                  paymentMethods: [],
                                                                  isConnectedFuelingEnabled: false,
                                                                  prices: [
                                                                    .init(value: 1.89,
                                                                          fuelType: .diesel,
                                                                          currency: "EUR",
                                                                          format: "d.dds")
                                                                  ],
                                                                  lastUpdated: Date(),
                                                                  openingHours: [])))
    }
    .padding(.paddingM)
}
