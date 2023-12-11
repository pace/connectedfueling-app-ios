// Copyright © 2023 PACE Telematics GmbH. All rights reserved.

import SwiftUI

struct PriceCardView: View {
    var title: String
    var priceText: AttributedString

    init(title: String, priceText: AttributedString) {
        self.title = title
        self.priceText = priceText
    }

    var body: some View {
        ZStack {
            Color(uiColor: Asset.Colors.lightGrey.color)
                .cornerRadius(8)
            VStack {
                TextLabel(title)
                    .font(.system(size: 14))
                    .multilineTextAlignment(.center)
                TextLabel(priceText)
            }
            .frame(alignment: .center)
            .padding(.horizontal, .paddingXXS)
        }
        .frame(width: 112, height: 63)
    }
}

#Preview {
    Group {
        PriceCardView(title: "Super", priceText: "1,699€")
            .previewLayout(.sizeThatFits)
        PriceCardView(title: "Super Premium", priceText: "9,999€")
            .previewLayout(.sizeThatFits)
    }
}
