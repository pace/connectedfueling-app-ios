import SwiftUI

struct MapTopAnnotationView: View {
    @ObservedObject private var viewModel: MapAnnotationViewModel

    private let annotationHeight: CGFloat
    private let annotationVerticalOffset: CGFloat

    init(viewModel: MapAnnotationViewModel) {
        self.viewModel = viewModel
        self.annotationHeight = viewModel.usesSmallHeight ? 38 : 65
        self.annotationVerticalOffset = viewModel.usesSmallHeight ? -5 : -3
    }

    var body: some View {
        VStack(spacing: 0) {
            Group {
                TextLabel(viewModel.name, textColor: viewModel.isClosed ? .genericGrey : .genericBlack)
                    .lineLimit(1)
                    .font(.system(size: 14))
                if viewModel.isClosed {
                    closedLabel
                        .padding(.top, 5)
                        .padding(.bottom, 5)
                } else if viewModel.showPrices,
                          let formattedPrice = viewModel.formattedPrice {
                    TextLabel(formattedPrice)
                        .font(.system(size: 24, weight: .heavy))
                }
            }
            .padding(.horizontal, 5)
        }
        .frame(width: 100, height: annotationHeight)
        .offset(.init(width: 0, height: annotationVerticalOffset))
        .background(tailShape)
    }

    @ViewBuilder
    private var closedLabel: some View {
        TextLabel(L10n.closedLabel.uppercased(), textColor: .genericGrey)
            .lineLimit(1)
            .font(.system(size: 10, weight: .bold))
            .padding(.all, 5)
            .frame(width: 90, height: 17)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(Color.genericWhite)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.genericGrey, lineWidth: 1)
                    )
            )
    }

    @ViewBuilder
    private var tailShape: some View {
        TailShape()
            .fill(Color.genericWhite.opacity(contentOpacity))
            .addShadow()
    }

    private var contentOpacity: CGFloat {
        viewModel.isClosed ? 0.7 : 1
    }
}

private extension MapTopAnnotationView {
    struct TailShape: Shape {
        private let tailSize: CGFloat = 10

        func path(in rect: CGRect) -> Path {
            var path = Path(roundedRect: .init(x: rect.minX,
                                               y: rect.minY,
                                               width: rect.width,
                                               height: rect.height - tailSize),
                            cornerRadius: 8)

            path.move(to: CGPoint(x: rect.midX - tailSize, y: rect.maxY - tailSize))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.midX + tailSize, y: rect.maxY - tailSize))
            return path
        }
    }
}

#Preview {
    ZStack {
        Rectangle()
            .frame(width: 200, height: 200)
            .foregroundStyle(Color.red)
        VStack(spacing: 10) {
            MapTopAnnotationView(viewModel: .init(annotation: .init(gasStation: .init(id: "",
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
            MapTopAnnotationView(viewModel: .init(annotation: .init(gasStation: .init(id: "",
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
                                                                                      ]))))
        }
    }
}

#Preview {
    MapTopAnnotationView.TailShape()
        .fill(Color.red)
        .frame(width: 100, height: 65)
}
