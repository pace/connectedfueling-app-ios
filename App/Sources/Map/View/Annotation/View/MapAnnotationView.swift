import SwiftUI

struct MapAnnotationView: View {
    @ObservedObject private var viewModel: MapAnnotationViewModel
    @Binding private var isTopAnnotationViewHidden: Bool

    init(viewModel: MapAnnotationViewModel, isTopAnnotationViewHidden: Binding<Bool>) {
        self.viewModel = viewModel
        self._isTopAnnotationViewHidden = isTopAnnotationViewHidden
    }

    var body: some View {
        NavigationLink(destination: GasStationDetailView(viewModel: .init(gasStation: viewModel.annotation.gasStation))) {
            content
        }
    }

    @ViewBuilder
    private var content: some View {
        ZStack(alignment: .bottom) {
            MapBottomAnnotationView(viewModel: viewModel)
                .padding(.bottom, -10)
            MapTopAnnotationView(viewModel: viewModel, isHidden: $isTopAnnotationViewHidden)
        }
    }
}

#Preview {
    VStack(spacing: 10) {
        MapAnnotationView(viewModel: .init(annotation: .init(gasStation: .init(id: "",
                                                                               name: "Tankstelle",
                                                                               addressLines: [],
                                                                               distanceInKilometers: nil,
                                                                               location: .init(latitude: 0,
                                                                                               longitude: 0),
                                                                               paymentMethods: [],
                                                                               isConnectedFuelingEnabled: true,
                                                                               prices: [
                                                                                .init(value: 1.89,
                                                                                      fuelType: .diesel,
                                                                                      currency: "EUR",
                                                                                      format: "d.dds")
                                                                               ],
                                                                               lastUpdated: nil,
                                                                               openingHours: []))),
                          isTopAnnotationViewHidden: .constant(false))
        MapAnnotationView(viewModel: .init(annotation: .init(gasStation: .init(id: "",
                                                                               name: "Tankstelle",
                                                                               addressLines: [],
                                                                               distanceInKilometers: nil,
                                                                               location: .init(latitude: 0,
                                                                                               longitude: 0),
                                                                               paymentMethods: [],
                                                                               isConnectedFuelingEnabled: true,
                                                                               prices: [
                                                                                .init(value: 1.89,
                                                                                      fuelType: .diesel,
                                                                                      currency: "EUR",
                                                                                      format: "d.dds")
                                                                               ],
                                                                               lastUpdated: nil,
                                                                               openingHours: [
                                                                                .init(days: [.sunday],
                                                                                      hours: [.init(from: "2", to: "3")],
                                                                                      rule: .open)
                                                                               ]))),
                          isTopAnnotationViewHidden: .constant(false))
        MapAnnotationView(viewModel: .init(annotation: .init(gasStation: .init(id: "",
                                                                               name: "Tankstelle",
                                                                               addressLines: [],
                                                                               distanceInKilometers: nil,
                                                                               location: .init(latitude: 0,
                                                                                               longitude: 0),
                                                                               paymentMethods: [],
                                                                               isConnectedFuelingEnabled: true,
                                                                               prices: [
                                                                                .init(value: 1.89,
                                                                                      fuelType: .diesel,
                                                                                      currency: "EUR",
                                                                                      format: "d.dds")
                                                                               ],
                                                                               lastUpdated: nil,
                                                                               openingHours: [
                                                                                .init(days: [.sunday],
                                                                                      hours: [.init(from: "2", to: "3")],
                                                                                      rule: .open)
                                                                               ]))),
                          isTopAnnotationViewHidden: .constant(true))
    }
}
