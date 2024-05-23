import SwiftUI

struct TransactionCell: View {
    @ObservedObject var viewModel: TransactionDetailViewModel

    var body: some View {
        HStack(alignment: .center) {
            info
            Spacer()
            if viewModel.showPrices {
                price
            }
        }
    }

    @ViewBuilder
    private var info: some View {
        VStack(alignment: .leading, spacing: 0) {
            if viewModel.isLatest {
                TextLabel(L10n.transactionsLastTransactionTitle, textColor: .primaryTint)
                    .font(.system(size: 14, weight: .bold))
                    .padding(.bottom, .paddingXXXS)
            }
            TextLabel("\(viewModel.date) · \(viewModel.time)")
                .font(.system(size: 16, weight: .bold))
                .padding(.bottom, .paddingXXXS)
            HStack(spacing: 0) {
                Image(.walletLocalGasStation)
                    .resizable()
                    .foregroundColor(.genericGrey)
                    .frame(width: 16, height: 16)
                TextLabel(viewModel.brand, textColor: .genericGrey)
                    .font(.system(size: 14))
            }
        }
    }

    @ViewBuilder
    private var price: some View {
        PriceCardView(title: viewModel.fuelType,
                      priceText: viewModel.attributedPrice)
        .padding(.vertical, .paddingXXS)
    }
}

#Preview {
    List {
        TransactionCell(viewModel: .init(transactionId: "id",
                                         day: "Donnerstag",
                                         date: "07.12.2023",
                                         time: "09:35 Uhr",
                                         brand: "Gasolina Stationa",
                                         address: "Haid-Und-Neu Straße 18, 76137 Karlsruhe",
                                         price: 47.53,
                                         amount: 25.85,
                                         fuelType: "Super",
                                         pricePerUnit: 1.839,
                                         paymentMethod: "paypal",
                                         pump: 1,
                                         currency: "EUR",
                                         unit: "Liter"))
        TransactionCell(viewModel: .init(transactionId: "id",
                                         day: "Donnerstag",
                                         date: "07.12.2023",
                                         time: "09:35 Uhr",
                                         brand: "Gasolina Stationa",
                                         address: "Haid-Und-Neu Straße 18, 76137 Karlsruhe",
                                         price: 470.53,
                                         amount: 25.85,
                                         fuelType: "Super",
                                         pricePerUnit: 1.839,
                                         paymentMethod: "paypal",
                                         pump: 1,
                                         currency: "EUR",
                                         unit: "Liter"))
    }
    .listStyle(.plain)
}
