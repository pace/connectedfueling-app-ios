// Copyright © 2023 PACE Telematics GmbH. All rights reserved.

import SwiftUI

struct TransactionDetailView: View {
    @ObservedObject var viewModel: TransactionDetailViewModel

    var body: some View {
        ScrollView {
            info
            price
            method
            receipt
        }
        .onAppear(perform: viewModel.detailWillAppear)
        .navigationTitle("Transaktionsdetails") // TODO: string
    }

    @ViewBuilder
    private var info: some View {
        ZStack {
            Color.primaryTintLight
            VStack {
                Image(.localGasStation)
                    .resizable()
                    .foregroundColor(.genericGrey)
                    .frame(width: 24, height: 24)
                    .padding(.vertical, .paddingXS)
                TextLabel(viewModel.brand)
                    .font(.system(size: 20, weight: .bold))
                    .padding(.bottom, 1)
                TextLabel(viewModel.address)
                    .font(.system(size: 16))
                    .padding(.bottom, 1)
//                TextLabel("Stationdetails", textColor: .primaryTint) // TODO: String
//                    .padding(.bottom, .paddingXS)
                TextLabel("\(viewModel.day), \(viewModel.date) · \(viewModel.time)")
                TextLabel("Zapfsäule \(viewModel.pump)") // TODO: String
            }
            .padding(.paddingS)
        }
    }

    @ViewBuilder
    private var price: some View {
            ZStack {
                Color.lightGrey
                    .cornerRadius(8)
                HStack {
                    VStack {
                        TextLabel("\(viewModel.amount) \(viewModel.unit) \(viewModel.fuelType)")
                        TextLabel("\(viewModel.pricePerUnit) \(viewModel.currency)/\(viewModel.unit)")
                    }
                    Spacer()
                    TextLabel(viewModel.attributedPrice)
                        .font(.system(size: 24, weight: .bold))
                }
                .padding(.paddingXS)
            }
        .padding(.paddingM)
    }

    @ViewBuilder
    private var method: some View {
        VStack {
            Image(systemName: "creditcard") // TODO: icon
                .resizable()
                .scaledToFit()
                .frame(width: 42, height: 24)
            TextLabel(viewModel.paymentMethod)
            if let email = viewModel.email {
                TextLabel(email, textColor: .primary)
            }
        }
        .padding(.bottom, .paddingS)
    }

    @ViewBuilder
    private var receipt: some View {
        if viewModel.isLoading {
            LoadingSpinner()
        } else if let image = viewModel.image {
            VStack {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .border(Color.genericBlack)
                    .padding(.paddingM)
                    .onTapGesture {
                        showShareSheet(image: image)
                    }
                Image(.arrowUpwardAlt)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.genericGrey)
                TextLabel("Tippe auf den Beleg um ihn zu speichern", textColor: .genericGrey) // TODO: string
                    .font(.system(size: 14))
                    .multilineTextAlignment(.center)
                    .padding(.bottom, .paddingL)
            }
        }
    }

    func showShareSheet(image: UIImage) {
        DispatchQueue.main.async {
            let shareObject = ShareObject(shareData: image, customTitle: "Receipt") // TODO: string

            let activityVC = UIActivityViewController(activityItems: [shareObject], applicationActivities: nil)
            UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
        }
    }
}

#Preview {
    TransactionDetailView(viewModel: .init(transactionId: "id",
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
}
