// Copyright © 2023 PACE Telematics GmbH. All rights reserved.

import Foundation
import PACECloudSDK

class TransactionListViewModel: ObservableObject {
    @Published var transactions: [TransactionDetailViewModel] = []

    @Published var isLoading: Bool = true

    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()

    let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter
    }()

    let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()

    init() {
        loadTransactions()
    }

    private func loadTransactions() {
        Task { @MainActor in
            isLoading = true
            guard let transactionsData = await fetchUserTransactions() else {
                isLoading = false
                return
            }

            transactions = transactionsData.compactMap { createDetailViewModel(with: $0) }

            if let first = transactions.first {
                first.isLatest = true
            }

            isLoading = false
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

    private func fetchUserTransactions() async -> PCPayTransactions? {
        let response = await transactions()

        switch response {
        case .success(let result):
            guard let transactions = result.success?.data else {
                NSLog("[TransactionListViewModel] Failed fetching user transactions - invalid data.")
                return nil
            }

            return transactions

        case .failure(let error):
            NSLog("[TransactionListViewModel] Failed fetching user transactions with error \(error).")
            return nil
        }
    }

    private func transactions() async -> APIResult<PayAPI.PaymentTransactions.ListTransactions.Response> {
        let options = PayAPI.PaymentTransactions.ListTransactions.Request.Options(sort: .createdAtDescending)
        let request = PayAPI.PaymentTransactions.ListTransactions.Request(options: options)

        let response = await makeRequest(request)

        if response.urlResponse?.statusCode == HttpStatusCode.unauthorized.rawValue {
//            NSLog("[APIControl.Pay] Failed refreshing the session. Will reset and attempt a new sign in...")
//            PaceIDControl.shared.renewSession()
            return .failure(.invalidDataError)
        } else {
            return response.result
        }
    }

    private func makeRequest<T: APIResponseValue>(_ request: PayAPIRequest<T>) async -> PayAPIResponse<T> {
       await API.Pay.client.makeRequest(request)
    }
}
