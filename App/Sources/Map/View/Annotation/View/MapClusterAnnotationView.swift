// Copyright © 2026 PACE Telematics GmbH. All rights reserved.

import SwiftUI

struct MapClusterAnnotationView: View {

    private let outerCircleSize: CGFloat = 30
    private let count: Int

    var body: some View {
        ZStack {
            Circle()
                .foregroundStyle(Color.genericWhite)
                .frame(width: outerCircleSize, height: outerCircleSize)
            Circle()
                .foregroundStyle(Color.primaryTint)
                .frame(width: outerCircleSize - 8, height: outerCircleSize - 8)
            Text("\(count)")
                .foregroundStyle(Color.genericWhite)
                .font(.system(size: 15))
        }
        .addShadow()
    }
    
    init(count: Int) {
        self.count = count
    }
}

#Preview {
    MapClusterAnnotationView(count: 3)
}
