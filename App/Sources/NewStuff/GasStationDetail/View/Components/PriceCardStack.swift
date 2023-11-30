// Copyright © 2023 PACE Telematics GmbH. All rights reserved.

import SwiftUI

struct PriceCardStack: View {
    let data: [PriceCardData]

    init(_ prices: [PriceCardData]) {
        self.data = prices
    }

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        LazyVGrid(columns: columns, content: {
            ForEach(data, id: \.self) { item in
                PriceCardView(title: item.fuelType, priceText: item.price)
            }
        })
    }
}

#Preview {
    PriceCardStack([
        .init(fuelType: "Super", price: "1,999€"),
        .init(fuelType: "Diesel", price: "1,899€"),
        .init(fuelType: "Super Plus", price: "2,039€"),
        .init(fuelType: "Super Duper", price: "2,099€"),
        .init(fuelType: "Super Super", price: "1,909€"),
        .init(fuelType: "Super extrem fuel", price: "2,799€"),
        .init(fuelType: "efdzfshdv", price: "1,999€"),
        .init(fuelType: "Diesel Miesel", price: "99,999€"),
        .init(fuelType: "Supi", price: "0,999€")
    ])
    .padding(.paddingM)
}
