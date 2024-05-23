import PACECloudSDK
import SwiftUI

class OnboardingAuthorizationPageViewModel: OnboardingPageViewModel {
    private var userManager: UserManager
    private var analyticsManager: AnalyticsManager

    init(style: ConfigurationManager.Configuration.OnboardingStyle,
         userManager: UserManager = .init(),
         analyticsManager: AnalyticsManager = .init()) {
        self.userManager = userManager
        self.analyticsManager = analyticsManager

        super.init(style: style,
                   image: .onboardingSignInIcon,
                   title: L10n.onboardingAuthenticationTitle,
                   description: L10n.onboardingAuthenticationDescription)
    }

    override func setupPageActions() {
        pageActions = [
            .init(title: L10n.onboardingAuthenticationAction, action: { [weak self] in
                guard let rootView = self?.rootView else { return }
                self?.authorize(rootView: rootView)
            })
        ]
    }

    // TODO: - Update
    /**

     In case we actually want to skip steps

    override func isPageAlreadyCompleted() async -> Bool {
        userManager.isAuthorizationValid
    }

     */

    private func authorize(rootView: some View) {
        let presentingViewController = UIHostingController(rootView: rootView)
        userManager.presentingViewController = presentingViewController

        Task { @MainActor [weak self] in
            guard let result = await self?.userManager.authorize() else { return }

            switch result {
            case .success(let accessToken):
                guard accessToken != nil else {
                    CofuLogger.e("[OnboardingViewModel] Failed authentication - invalid token")
                    self?.alert = AppAlert.genericError
                    return
                }

                self?.analyticsManager.logEvent(AnalyticEvents.UserSignedInEvent())
                self?.finishOnboardingPage()

            case .failure(let error):
                if let error = error as? IDKit.IDKitError,
                   case .authorizationCanceled = error {} else {
                       CofuLogger.e("[OnboardingViewModel] Failed authentication with error \(error)")
                       self?.alert = AppAlert.genericError
                }
            }
        }
    }
}
