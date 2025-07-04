import Foundation
import PACECloudSDK

class TransactionListViewModel: ObservableObject {
    private let pageSize = 25

    private var currentPage = 0
    private var lastPageLength: Int?

    private var hasNextPage: Bool {
        lastPageLength == pageSize
    }

    private var transactions: [TransactionDetailViewModel]?

    @Published private(set) var isLoading: Bool = true
    @Published private(set) var error: AppError?

    @Published var state: PaginatedUIState<[TransactionDetailViewModel]> = .initialLoading

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

        Task {
            await loadTransactions(currentPage)
        }
    }

    @Sendable func refresh() async {
        currentPage = 0
        await loadTransactions(currentPage, reset: true)
    }

    func loadNextPageIfNeeded() {
        guard !state.isLoading, let transactions, hasNextPage else { return }

        currentPage += 1
        state = .loadingNextPage(transactions)
        Task { @MainActor in
            await loadTransactions(currentPage)
        }
    }

    @MainActor
    private func loadTransactions(_ page: Int, reset: Bool = false) async {
        let result = await paymentManager.transactions(page: page, pageSize: pageSize)

        switch result {
        case .success(let apiTransactions):
            let listItems: [TransactionDetailViewModel] = apiTransactions.compactMap { createDetailViewModel(with: $0) }

            lastPageLength = listItems.count

            if !reset && transactions != nil {
                transactions?.append(contentsOf: listItems)
            } else {
                transactions = listItems
            }

            transactions?.first?.isLatest = true

            guard let transactions else {
                CofuLogger.e("[TransactionListViewModel] No transactions")
                return
            }

            if hasNextPage {
                state = .hasNextPage(transactions)
            } else {
                state = .loadedAllPages(transactions)
            }

        case .failure(let error):
            CofuLogger.e("[TransactionListViewModel] Failed fetching payment methods with error \(error)")
            state = .failure(transactions, nil)
            setError()
        }
    }

    func setError() {
        self.error = .init(title: L10n.commonUseErrorTitle,
                           description: L10n.commonUseErrorDescription,
                           retryAction: .init(title: L10n.commonUseRetry, action: { [weak self] in
            Task {
                await self?.refresh()
            }
        }))
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
