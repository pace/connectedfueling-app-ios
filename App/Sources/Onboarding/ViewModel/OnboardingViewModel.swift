import Foundation

class OnboardingViewModel: ObservableObject {
    @Published var currentPage: Int = 0

    var pageViewModels: [OnboardingPageViewModel]

    private let style: ConfigurationManager.Configuration.OnboardingStyle

    init(configuration: ConfigurationManager.Configuration = ConfigurationManager.configuration) {
        self.style = configuration.onboardingStyle

        pageViewModels = [
            OnboardingLegalPageViewModel(style: style),
            OnboardingLocationPermissionPageViewModel(style: style),
            OnboardingAuthorizationPageViewModel(style: style),
            OnboardingTwoFactorAuthenticationPageViewModel(style: style),
            OnboardingPaymentMethodsPageViewModel(style: style)
        ]

        if configuration.isAnalyticsEnabled {
            pageViewModels.insert(OnboardingAnalyticsPageViewModel(style: style), at: 1)
        }

        if !configuration.hidePrices {
            pageViewModels.append(
                OnboardingFuelTypePageViewModel(style: style)
            )
        }

        setupDelegates()
    }

    private func setupDelegates() {
        pageViewModels.forEach {
            $0.onboardingViewModel = self
        }
    }

    @MainActor
    private func nextIncompletePage(page: Int) async -> Int? {
        guard let isNextPageCompleted = await pageViewModels[safe: page]?.isPageAlreadyCompleted() else { return nil }
        return isNextPageCompleted ? await nextIncompletePage(page: page + 1) : page
    }

    func nextPage() {
        Task { @MainActor [weak self] in
            guard let self else { return }

            guard let currentPageViewModel = self.pageViewModels[safe: self.currentPage] else { return }

            currentPageViewModel.isCheckingNextPages = true
            let nextIncompletePage = await self.nextIncompletePage(page: self.currentPage + 1)
            currentPageViewModel.isCheckingNextPages = false

            if let nextIncompletePage {
                self.currentPage = nextIncompletePage
            } else {
                UserDefaults.isOnboardingCompleted = true
            }
        }
    }
}
