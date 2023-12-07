import SwiftUI

struct MapBottomAnnotationView: View {
    @ObservedObject private var viewModel: MapAnnotationViewModel
    
    private let outerCircleSize: CGFloat = 15

    init(viewModel: MapAnnotationViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ZStack {
            Circle()
                .foregroundStyle(Color.genericWhite)
                .frame(width: outerCircleSize, height: outerCircleSize)
            Circle()
                .foregroundStyle(viewModel.isClosed ? Color.genericGrey : Color.primaryTint)
                .frame(width: outerCircleSize - 4, height: outerCircleSize - 4)
            Circle()
                .frame(width: 3, height: 3)
                .foregroundStyle(Color.genericWhite)
        }
        .addShadow()
    }
}

#Preview {
    MapBottomAnnotationView(viewModel: .init(annotation: .init(gasStation: .init(id: "",
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
                                                                                 openingHours: []))))
}
