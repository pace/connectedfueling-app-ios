// Copyright © 2023 PACE Telematics GmbH. All rights reserved.

import SwiftUI

struct MapGasStationBottomMarkerView: View {
    var body: some View {
        ZStack {
            Circle()
                .foregroundStyle(Color.primaryTint)
                .frame(width: 15, height: 15)
            Circle()
                .strokeBorder(Color.genericWhite, lineWidth: 2)
                .frame(width: 15, height: 15)
            Circle()
                .frame(width: 3, height: 3)
                .foregroundStyle(Color.genericWhite)
        }
        .shadow(radius: 5)
    }
}

#Preview {
    MapGasStationBottomMarkerView()
}
