import Foundation
import PACECloudSDK

class TransactionListViewModel: ObservableObject {
    @Published private(set) var transactions: [TransactionDetailViewModel] = []
    @Published private(set) var isLoading: Bool = true
    @Published private(set) var error: AppError?

    let emptyTransactionsError: AppError = .init(title: L10n.transactionsEmptyTitle,
                                                 description: L10n.transactionsEmptyDescription,
                                                 icon: .image(.transactionIcon.renderingMode(.template)))

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()

    private let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter
    }()

    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()

    private let paymentManager: PaymentManager

    init(paymentManager: PaymentManager = .init()) {
        self.paymentManager = paymentManager

        fetchTransactions()
    }

    func fetchTransactions() {
        Task { @MainActor [weak self] in
            defer {
                self?.isLoading = false
            }

            self?.isLoading = true

            guard let result = await self?.paymentManager.transactions() else { return }

            switch result {
            case .success(let transactions):
                let transactionsViewModels = transactions.compactMap { self?.createDetailViewModel(with: $0) }
                transactionsViewModels.first?.isLatest = true
                self?.transactions = transactionsViewModels

            case .failure(let error):
                CofuLogger.e("[TransactionListViewModel] Failed fetching payment methods with error \(error)")
                self?.error = .init(title: L10n.commonUseErrorTitle,
                                    description: L10n.commonUseErrorDescription,
                                    retryAction: .init(title: L10n.commonUseRetry, action: { [weak self] in
                    self?.fetchTransactions()
                }))
            }
        }
    }

    private func createDetailViewModel(with transactionData: PCPayTransaction) -> TransactionDetailViewModel? {
        guard let id = transactionData.id,
              let date = transactionData.createdAt,
              let stationLocation = transactionData.location,
              let brand = stationLocation.brand,
              let stationAddress = stationLocation.address,
              let price = transactionData.priceIncludingVAT,
              let stationFuel = transactionData.fuel,
              let amount = stationFuel.amount,
              let fuelType = stationFuel.productName,
              let pricePerUnit = stationFuel.pricePerUnit,
              let paymentMethod = transactionData.paymentMethodKind,
              let pump = stationFuel.pumpNumber,
              let currency = transactionData.currency,
              let unit = stationFuel.unit else { return nil }

        let dateText = dateFormatter.string(from: date)
        let dayText = dayFormatter.string(from: date)
        let timeText = timeFormatter.string(from: date)

        var addressText: String = ""

        if let street = stationAddress.street {
            addressText.append(street)
            if let number = stationAddress.houseNo {
                addressText.append(" " + number)
            }
        }

        if let plz = stationAddress.postalCode {
            addressText.append(", " + plz)
        }

        if let city = stationAddress.city {
            if stationAddress.postalCode == nil {
                addressText.append(", " + city)
            } else {
                addressText.append(" " + city)
            }
        }

        return .init(transactionId: id,
                     day: dayText,
                     date: dateText,
                     time: timeText,
                     brand: brand,
                     address: addressText,
                     price: price.toDouble,
                     amount: amount,
                     fuelType: fuelType,
                     pricePerUnit: pricePerUnit,
                     paymentMethod: paymentMethod,
                     pump: pump,
                     currency: currency,
                     unit: unit)
    }
}
