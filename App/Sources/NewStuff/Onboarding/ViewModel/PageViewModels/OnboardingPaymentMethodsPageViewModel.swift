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

    init(style: ConfigurationManager.Configuration.OnboardingStyle,
         paymentManager: PaymentManager = .init()) {
        self.paymentManager = paymentManager

        super.init(style: style,
                   image: .onboardingPaymentMethodIcon,
                   title: L10n.onboardingPaymentMethodTitle,
                   description: L10n.onboardingPaymentMethodDescription)
    }

    override func setupPageActions() {
        pageActions = [
            .init(title: L10n.onboardingPaymentMethodAction, action: { [weak self] in
                self?.appUrlString = PACECloudSDK.URL.payment.absoluteString
            })
        ]
    }

    override func isPageAlreadyCompleted() async -> Bool {
        await hasPaymentMethods()
    }

    override func didDismissAppView() {
        super.didDismissAppView()
        finishOnboardingPage()
    }

    private func hasPaymentMethods() async -> Bool {
        let result = await paymentManager.hasPaymentMethods()

        switch result {
        case .success(let hasPaymentMethods):
            return hasPaymentMethods

        case .failure(let error):
            NSLog("[OnboardingPaymentMethodsPageViewModel] Failed checking payment methods with error \(error)")
            alert = AppAlert.genericError
            return false
        }
    }
}
