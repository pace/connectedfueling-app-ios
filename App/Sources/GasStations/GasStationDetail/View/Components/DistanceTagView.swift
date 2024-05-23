import SwiftUI

struct DistanceTagView: View {
    enum Style {
        case nearby
        case distant(String)
        case closed(String)

        var color: Color {
            switch self {
            case .nearby:
                Color.genericGreen

            case .distant:
                Color.genericOrange

            case .closed:
                Color.genericRed
            }
        }

        var text: String {
            switch self {
            case .nearby:
                L10n.gasStationLocationHere

            case .closed(let distance):
                L10n.gasStationLocationAway(distance)

            case .distant(let distance):
                L10n.gasStationLocationAway(distance)
            }
        }
    }

    private let style: Style

    init(_ style: Style) {
        self.style = style
    }

    var body: some View {
        HStack {
            Image("detail_arrows_outward")
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .foregroundColor(Color.genericWhite)
                .frame(width: 20, height: 10)
            TextLabel(style.text, textColor: Color.genericWhite)
                .font(.system(size: 14, weight: .bold))
        }
        .padding(.horizontal, .paddingXXS)
        .padding(.vertical, .paddingXXXS)
        .background(style.color)
        .cornerRadius(12)
    }
}

#Preview {
    VStack {
        DistanceTagView(.nearby)
        DistanceTagView(.distant("1.23 km"))
        DistanceTagView(.closed("989 km"))
    }
}
