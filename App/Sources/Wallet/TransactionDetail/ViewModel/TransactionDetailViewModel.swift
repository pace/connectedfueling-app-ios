import Foundation
import PACECloudSDK
import SwiftUI

class TransactionDetailViewModel: ObservableObject, Identifiable {
    @Published var isLoading: Bool = true

    @Published var image: UIImage?

    let transactionId: String
    let day: String
    let date: String
    let time: String
    let brand: String
    let address: String
    let price: Double
    let amount: Decimal
    let fuelType: String
    let pricePerUnit: Decimal
    let paymentMethod: String
    let pump: Int
    let currency: String
    let unit: String
    var isLatest: Bool = false

    var email: String? {
        userManager.email
    }

    private let userManager: UserManager

    var attributedPrice: AttributedString {
        let currencySymbol = NSLocale.symbol(for: currency)

        guard let formattedPriceValue = priceFormatter.localizedPrice(from: NSNumber(value: price), currencySymbol: currencySymbol) else {
            return .init(L10n.Price.notAvailable)
        }

        return formattedPriceValue
    }

    private let priceFormatter: PriceNumberFormatter

    init(userManager: UserManager = .init(), transactionId: String,
         day: String, date: String, time: String, brand: String,
         address: String, price: Double, amount: Decimal,
         fuelType: String, pricePerUnit: Decimal, paymentMethod: String,
         pump: Int, currency: String, unit: String) {
        self.userManager = userManager
        self.priceFormatter = PriceNumberFormatter(with: "d.dd")

        self.transactionId = transactionId
        self.day = day
        self.date = date
        self.time = time
        self.brand = brand
        self.address = address
        self.price = price
        self.amount = amount
        self.fuelType = fuelType
        self.pricePerUnit = pricePerUnit
        self.paymentMethod = paymentMethod
        self.pump = pump
        self.currency = currency
        self.unit = unit
    }

    func detailWillAppear() {
        loadReceipt()
    }

    private func loadReceipt() {
        if image == nil {
            Task { @MainActor in
                isLoading = true

                let result = await self.receipt()

                if case let .success(response) = result {
                    guard let imageData = response.success,
                          let uiImage = UIImage(data: imageData) else { return }
                    self.image = uiImage
                }

                isLoading = false
            }
        }
    }

    private func receipt() async -> APIResult<PayAPI.PaymentTransactions.GetReceipt.Response> {
        let options = PayAPI.PaymentTransactions.GetReceipt.Request.Options(transactionID: transactionId)
        let request = PayAPI.PaymentTransactions.GetReceipt.Request(options: options)

        let response = await makeRequest(request)

        return response.result
    }

    private func makeRequest<T: APIResponseValue>(_ request: PayAPIRequest<T>) async -> PayAPIResponse<T> {
       await API.Pay.client.makeRequest(request)
    }
}
