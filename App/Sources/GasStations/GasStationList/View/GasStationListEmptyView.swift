import SwiftUI

struct GasStationListEmptyView: View {
    var body: some View {
        VStack(spacing: 0) {
            Image(.gasStationListNoResults)
            Group {
                TextLabel(L10n.Dashboard.EmptyView.title, alignment: .center)
                    .font(.system(size: 20, weight: .medium))
                    .padding(.top, 40)
                TextLabel(L10n.Dashboard.EmptyView.description, alignment: .center)
                    .font(.system(size: 16, weight: .medium))
                    .padding(.top, 10)
                    .padding(.horizontal, 25)
            }
            .padding(.horizontal, 25)
        }
    }
}

#Preview {
    GasStationListEmptyView()
}
