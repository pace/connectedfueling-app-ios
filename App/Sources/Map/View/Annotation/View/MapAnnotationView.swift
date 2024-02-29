import SwiftUI

struct MapAnnotationView: View {
    @ObservedObject private var viewModel: MapAnnotationViewModel
    @Binding private var isTopAnnotationViewHidden: Bool

    private let smallTopAnnotationOffset: CGFloat = -20.0
    private let normalTopAnnotationOffset: CGFloat = -35.0

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
        ZStack {
            MapBottomAnnotationView(viewModel: viewModel)
            if !isTopAnnotationViewHidden {
                MapTopAnnotationView(viewModel: viewModel)
                    .offset(x: 0, y: viewModel.usesSmallHeight ? smallTopAnnotationOffset : normalTopAnnotationOffset)
            }
        }
    }
}

#Preview {
    VStack(spacing: 30) {
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
