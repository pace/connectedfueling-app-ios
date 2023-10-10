import Foundation

class OnboardingViewModel: ObservableObject {
    @Published var isOnboardingCompleted: Bool
    @Published var currentPage: Int = 0

    var pageViewModels: [OnboardingPageViewModel]

    init() {
        isOnboardingCompleted = AppUserDefaults.value(for: Constants.UserDefaults.isOnboardingCompleted) ?? false

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
            AppUserDefaults.set(true, for: Constants.UserDefaults.isOnboardingCompleted)
            isOnboardingCompleted = true
        } else {
            currentPage = newPage
            checkNextPreconditions()
        }
    }
}
