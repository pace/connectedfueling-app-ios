// Copyright © 2023 PACE Telematics GmbH. All rights reserved.

import SwiftUI

struct PageIndicatorView: View {
    let numberOfPages: Int
    @Binding var selectedIndex: Int

    private let dashWidth: CGFloat = 40
    private let dashHeight: CGFloat = 3
    private let dashCornerRadius: CGFloat = 1.5
    private let dashSpacing: CGFloat = 10
    private let primaryColor = Color.pageIndicatorForeground
    private let secondaryColor = Color.pageIndicatorBackground

    var body: some View {
        HStack(spacing: dashSpacing) {
            ForEach(0..<numberOfPages, id: \.self) { index in
                Rectangle()
                    .fill($selectedIndex.wrappedValue == index ? primaryColor : secondaryColor)
                    .frame(width: dashWidth, height: dashHeight)
                    .id(index)
            }
        }
    }
}

#Preview {
    PageIndicatorView( numberOfPages: 5, selectedIndex: .constant(3))
}
