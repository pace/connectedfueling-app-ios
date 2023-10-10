import PACECloudSDK
import SwiftUI

class OnboardingPaymentMethodsPageViewModel: OnboardingPageViewModel {
    private let paymentManager: PaymentManager

    private var isRequestRunning: Bool = false {
        didSet {
            isLoading = isRequestRunning
            isActionDisabled = isRequestRunning
        }
    }

    init(paymentManager: PaymentManager = .init()) {
        self.paymentManager = paymentManager

        super.init(image: .paymentMethod,
                   title: L10n.Onboarding.PaymentMethod.title,
                   description: L10n.Onboarding.PaymentMethod.description)

        appUrlString = PACECloudSDK.URL.payment.absoluteString
    }

    override func setupPageActions() {
        pageActions = [
            .init(title: L10n.Onboarding.Actions.addPaymentMethod, action: { [weak self] in
                self?.showAppView = true
            })
        ]
    }

    override func checkPreconditions() {
        super.checkPreconditions()
        checkHasPaymentMethods()
    }

    override func didDismissAppView() {
        super.didDismissAppView()
        finishOnboardingPage()
    }

    private func checkHasPaymentMethods() {
        Task { @MainActor [weak self] in
            self?.isLoading = true
            let result = await self?.paymentManager.hasPaymentMethods() ?? .failure(APIClientError.invalidDataError)
            self?.isLoading = false

            switch result {
            case .success(let hasPaymentMethods):
                if hasPaymentMethods {
                    self?.finishOnboardingPage()
                }

            case .failure(let error):
                NSLog("[OnboardingPaymentMethodsPageViewModel] Failed checking payment methods with error \(error)")
                self?.isErrorAlertPresented = true
            }
        }
    }
}
