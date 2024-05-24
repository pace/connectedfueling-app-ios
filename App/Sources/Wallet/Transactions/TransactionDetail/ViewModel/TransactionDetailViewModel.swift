import Foundation
import PACECloudSDK
import SwiftUI

class TransactionDetailViewModel: ObservableObject, Identifiable {
    @Published var isLoading: Bool = true
    @Published var receiptData: TransactionReceiptData?

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

    let showPrices: Bool

    private let userManager: UserManager
    private let paymentManager: PaymentManager

    var attributedPrice: AttributedString {
        let currencySymbol = NSLocale.symbol(for: currency)

        guard let formattedPriceValue = priceFormatter.localizedPrice(from: NSNumber(value: price), currencySymbol: currencySymbol) else {
            return .init(L10n.Price.notAvailable)
        }

        return formattedPriceValue
    }

    private let priceFormatter: PriceNumberFormatter

    init(transactionId: String,
         day: String,
         date: String,
         time: String,
         brand: String,
         address: String,
         price: Double,
         amount: Decimal,
         fuelType: String,
         pricePerUnit: Decimal,
         paymentMethod: String,
         pump: Int,
         currency: String,
         unit: String,
         userManager: UserManager = .init(),
         paymentManager: PaymentManager = .init(),
         configuration: ConfigurationManager.Configuration = ConfigurationManager.configuration) {
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
        self.userManager = userManager
        self.paymentManager = paymentManager
        self.showPrices = !configuration.hidePrices
        self.priceFormatter = PriceNumberFormatter(with: "d.dd")
    }

    func loadReceipt() {
        guard receiptData == nil else { return }

        Task { @MainActor [weak self] in
            defer {
                self?.isLoading = false
            }

            self?.isLoading = true

            guard let self else { return }

            async let imageResult = await self.paymentManager.receipt(transactionId: self.transactionId, format: .png)
            async let pdfResult = await self.paymentManager.receipt(transactionId: self.transactionId, format: .pdf)

            guard case .success(let imageData) = await imageResult,
                  case .success(let pdfData) = await pdfResult,
                  let uiImage: UIImage = .init(data: imageData) else {
                CofuLogger.e("[TransactionDetailViewModel] Failed loading receipt")
                return
            }

            self.receiptData = .init(image: uiImage, pdf: pdfData)
        }
    }
}
