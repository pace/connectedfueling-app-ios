// Copyright © 2023 PACE Telematics GmbH. All rights reserved.

import SwiftUI

struct PriceUnavailableCardView: View {
    var body: some View {
        ZStack {
            Color(uiColor: Asset.Colors.lightGrey.color)
                .cornerRadius(8)
            VStack {
                TextLabel(L10n.listPriceNotAvailable)
                    .font(.system(size: 14))
            }
            .frame(alignment: .center)
            .padding(.horizontal, .paddingXXS)
        }
        .frame(width: 112, height: 63)
    }
}

#Preview {
    PriceUnavailableCardView()
}
