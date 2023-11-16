import Foundation

class OnboardingViewModel: ObservableObject {
    @Published var currentPage: Int = 0

    var pageViewModels: [OnboardingPageViewModel]

    init() {
        pageViewModels = [
            OnboardingLocationPermissionPageViewModel(),
            OnboardingAuthorizationPageViewModel(),
            OnboardingTwoFactorAuthenticationPageViewModel(),
            OnboardingPaymentMethodsPageViewModel(),
            OnboardingFuelTypePageViewModel()
        ]

        setupDelegates()
    }

    private func setupDelegates() {
        pageViewModels.forEach {
            $0.onboardingViewModel = self
        }
    }

    func checkNextPreconditions() {
        pageViewModels[safe: currentPage]?.checkPreconditions()
    }

    func nextPage() {
        let newPage = currentPage + 1

        if newPage == pageViewModels.count {
            UserDefaults.standard.set(true, forKey: Constants.UserDefaults.isOnboardingCompleted)
        } else {
            currentPage = newPage
            checkNextPreconditions()
        }
    }
}
