import PACECloudSDK
import SwiftUI

class OnboardingAuthorizationPageViewModel: OnboardingPageViewModel {
    private var userManager: UserManager

    init(userManager: UserManager = .init()) {
        self.userManager = userManager

        super.init(image: .profile,
                   title: L10n.Onboarding.Authentication.title,
                   description: L10n.Onboarding.Authentication.description)
    }

    override func setupPageActions() {
        pageActions = [
            .init(title: L10n.Onboarding.Actions.authenticate, action: { [weak self] in
                guard let rootView = self?.rootView else { return }
                self?.authorize(rootView: rootView)
            })
        ]
    }

    override func checkPreconditions() {
        super.checkPreconditions()

        if userManager.isAuthorizationValid {
            finishOnboardingPage()
        }
    }

    private func authorize(rootView: some View) {
        let presentingViewController = UIHostingController(rootView: rootView)
        userManager.presentingViewController = presentingViewController

        Task { @MainActor [weak self] in
            guard let result = await self?.userManager.authorize() else { return }

            switch result {
            case .success(let accessToken):
                guard accessToken != nil else {
                    NSLog("[OnboardingViewModel] Failed authentication - invalid token")
                    self?.isErrorAlertPresented = true
                    return
                }

                self?.finishOnboardingPage()

            case .failure(let error):
                if let error = error as? IDKit.IDKitError,
                   case .authorizationCanceled = error {} else {
                    NSLog("[OnboardingViewModel] Failed authentication with error \(error)")
                    self?.isErrorAlertPresented = true
                }
            }
        }
    }
}
