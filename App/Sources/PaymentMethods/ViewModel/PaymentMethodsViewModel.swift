import Foundation

class PaymentMethodsViewModel: ObservableObject {
    @Published private(set) var isLoading: Bool = true
    @Published private(set) var error: AppError?
    @Published private(set) var paymentMethodViewModels: [PaymentMethodViewModel] = []
    @Published var paymentAppUrlString: String?
    private(set) var isNativePaymentMethodOnboardingEnabled: Bool

    let emptyPaymentMethodsError: AppError = .init(title: L10n.paymentMethodsEmptyTitle,
                                                   description: L10n.paymentMethodsEmptyDescription,
                                                   icon: .image(.paymentMethodIcon))

    private let paymentManager: PaymentManager

    init(paymentManager: PaymentManager = .init()) {
        self.paymentManager = paymentManager
        self.isNativePaymentMethodOnboardingEnabled = UserDefaults.isNativePaymentMethodOnboardingEnabled
    }

    func fetchPaymentMethods() {
        isLoading = true
        Task { @MainActor [weak self] in
            defer {
                self?.isLoading = false
            }

            guard let result = await self?.paymentManager.paymentMethods() else { return }

            switch result {
            case .success(let paymentMethods):
                self?.paymentMethodViewModels = paymentMethods.map { .init(paymentMethod: $0, delegate: self) }

            case .failure(let error):
                CofuLogger.e("[PaymentMethodsViewModel] Failed fetching payment methods with error \(error)")
                self?.error = .init(title: "Oops, something went wrong",
                                    description: "Please try again",
                                    retryAction: .init(title: "Try again", action: { [weak self] in
                    self?.fetchPaymentMethods()
                }))
            }
        }
    }

    func showPaymentMethodApp(for id: String, kind: String) {
        paymentAppUrlString = paymentManager.paymentMethodUrlString(for: id, kind: kind)
    }

    func showPaymentApp() {
        paymentAppUrlString = paymentManager.paymentAppUrlString
    }

    func didClosePaymentApp() {
        paymentAppUrlString = nil
        fetchPaymentMethods()
    }
}
