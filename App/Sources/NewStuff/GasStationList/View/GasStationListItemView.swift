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
            HStack(alignment: .center, spacing: 0) {
                details
                Spacer()
                priceLabel
            }
            ActionButton(title: viewModel.actionTitle,
                         style: viewModel.gasStation.isConnectedFuelingEnabled ? .primary : .ternary) {
                // Since buttons that are included in a list behave differently
                // than intended, e.g not highlighted when tapped and the List treats
                // the entire list item as the button,
                // set the button' style to `plain`
                viewModel.didTapActionButton()
            }
            .buttonStyle(.plain)
            .padding(.top, 20)
        }
        .padding(.all, 20)
    }

    @ViewBuilder
    private var details: some View {
        VStack(alignment: .leading, spacing: 0) {
            TextLabel(viewModel.gasStation.name)
                .font(.system(size: 18, weight: .semibold))
                .padding(.bottom, 10)
            ForEach(viewModel.gasStation.addressLines, id: \.self) { addressLine in
                TextLabel(addressLine)
                    .font(.system(size: 16, weight: .medium))
            }
            HStack {
                Image(.navigation)
                    .foregroundStyle(Color.primaryTint)
                TextLabel(viewModel.formattedDistance, textColor: .primaryTint)
                    .font(.system(size: 16, weight: .medium))
            }
        }
    }

    @ViewBuilder
    private var priceLabel: some View {
        ZStack {
            priceLabelBackgroundContainer
            priceLabelContent
        }
    }

    @ViewBuilder
    private var priceLabelBackgroundContainer: some View {
        Rectangle()
            .frame(width: 100, height: 50)
            .foregroundStyle(Color.lightGrey)
            .cornerRadius(8)
    }

    @ViewBuilder
    private var priceLabelContent: some View {
        VStack(alignment: .center, spacing: 0) {
            TextLabel(viewModel.formattedFuelType)
                .font(.system(size: 12, weight: .medium))
            TextLabel(viewModel.formattedPrice)
                .font(.system(size: 20, weight: .semibold))
        }
        .padding(.all, 5)
    }
}

#Preview {
    VStack {
        GasStationListItemView(viewModel: .init(gasStation: .init(id: "id",
                                                                  name: "MobyPay 3435",
                                                                  addressLines: [
                                                                    "Gerwigstraße 2",
                                                                    "76131 Karlsruhe"
                                                                  ],
                                                                  distanceInKilometers: 0.234,
                                                                  location: nil,
                                                                  paymentMethods: [],
                                                                  isConnectedFuelingEnabled: true,
                                                                  fuelType: .init(rawValue: "ron95e5"),
                                                                  fuelPrice: .init(value: 1.38,
                                                                                   currency: "EUR",
                                                                                   format: "d.dds"), 
                                                                  prices: [],
                                                                  lastUpdated: Date(),
                                                                  openingHours: [])))
        GasStationListItemView(viewModel: .init(gasStation: .init(id: "id",
                                                                  name: "MobyPay 3435",
                                                                  addressLines: [
                                                                    "Gerwigstraße 2",
                                                                    "76131 Karlsruhe"
                                                                  ],
                                                                  distanceInKilometers: 0.234,
                                                                  location: nil,
                                                                  paymentMethods: [],
                                                                  isConnectedFuelingEnabled: false,
                                                                  fuelType: nil,
                                                                  fuelPrice: nil,
                                                                  prices: [],
                                                                  lastUpdated: Date(),
                                                                  openingHours: [])))
    }
}
