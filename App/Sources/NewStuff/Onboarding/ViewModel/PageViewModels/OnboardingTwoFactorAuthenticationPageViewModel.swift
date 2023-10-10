import SwiftUI

// swiftlint:disable type_name
class OnboardingTwoFactorAuthenticationPageViewModel: OnboardingPageViewModel {
    private let userManager: UserManager
    private var configuredTwoFactorAuthenticationMethods: Set<UserManager.TwoFactorAuthenticationMethod> = []

    private var isRequestRunning: Bool = false {
        didSet {
            isLoading = isRequestRunning
            isActionDisabled = isRequestRunning
        }
    }

    init(userManager: UserManager = .init()) {
        self.userManager = userManager

        super.init(image: .biometry,
                   title: L10n.Onboarding.TwoFactorAuthentication.title,
                   description: L10n.Onboarding.TwoFactorAuthentication.description,
                   pageActions: [
                    .init(title: L10n.Onboarding.TwoFactorAuthentication.pin, action: {}) // Placeholder action
                   ])
    }

    override func checkPreconditions() {
        super.checkPreconditions()
        determineTwoFactorAuthenticationConfiguration()
    }

    private func determineTwoFactorAuthenticationConfiguration() {
        Task { @MainActor [weak self] in
            self?.isRequestRunning = true

            let configuredTwoFactorAuthenticationMethods = await self?.userManager.configuredTwoFactorAuthenticationMethods() ?? []
            let availableTwoFactorAuthenticationMethods = self?.userManager.availableTwoFactorAuthenticationMethods() ?? []

            self?.configuredTwoFactorAuthenticationMethods = configuredTwoFactorAuthenticationMethods
            self?.isRequestRunning = false

            guard !availableTwoFactorAuthenticationMethods.subtracting(configuredTwoFactorAuthenticationMethods).isEmpty else {
                // If empty, available methods are already configured
                self?.finishOnboardingPage()
                return
            }

            var pageActions: [OnboardingPageAction] = [
                .init(title: L10n.Onboarding.TwoFactorAuthentication.pin, action: { [weak self] in
                    self?.requestTwoFactorAuthenticationWithPIN()
                })
            ]

            if availableTwoFactorAuthenticationMethods.contains(.biometry) {
                pageActions.insert(
                    .init(title: L10n.Onboarding.TwoFactorAuthentication.biometry, action: { [weak self] in
                        self?.requestTwoFactorAuthenticationWithBiometry()
                    }), at: 0)
            }

            self?.pageActions = pageActions
        }
    }

    private func requestTwoFactorAuthenticationWithPIN() {
        guard !configuredTwoFactorAuthenticationMethods.contains(.pin) else {
            finishOnboardingPage()
            return
        }

        textInputViewModel = .init(type: .pin) { [weak self] response in
            if case .pin(let pin, let otp) = response {
                self?.setPIN(pin, otp: otp)
            }

            self?.textInputViewModel = nil
        }
    }

    private func setPIN(_ pin: String, otp: String) {
        Task { @MainActor [weak self] in
            guard let result = await self?.userManager.setPIN(pin: pin, otp: otp) else { return }

            switch result {
            case .success(let didSetPIN):
                guard didSetPIN else {
                    NSLog("[OnboardingTwoFactorAuthenticationPageViewModel] Failed setting PIN")
                    self?.isErrorAlertPresented = true
                    return
                }

                self?.finishOnboardingPage()

            case .failure(let error):
                NSLog("[OnboardingTwoFactorAuthenticationPageViewModel] Failed setting pin with \(error)")
                self?.isErrorAlertPresented = true
            }
        }
    }

    private func requestTwoFactorAuthenticationWithBiometry(otp: String? = nil) {
        guard !configuredTwoFactorAuthenticationMethods.contains(.biometry) else {
            finishOnboardingPage()
            return
        }

        Task { @MainActor [weak self] in
            guard let result = await self?.userManager.enableBiometricAuthentication(otp: otp) else { return }

            switch result {
            case .success(let isEnabled):
                guard isEnabled else {
                    NSLog("[OnboardingTwoFactorAuthenticationPageViewModel] Failed enabling biometric authentication")
                    self?.isErrorAlertPresented = true
                    return
                }

                self?.finishOnboardingPage()

            case .failure(let error):
                NSLog("[OnboardingTwoFactorAuthenticationPageViewModel] Failed enabling biometric authentication with error \(error)")

                guard otp == nil else {
                    self?.isErrorAlertPresented = true
                    return
                }

                self?.requestMailOTPForBiometry()
            }
        }
    }

    private func requestMailOTPForBiometry() {
        Task { @MainActor [weak self] in
            guard let result = await self?.userManager.sendMailOTP() else { return }

            switch result {
            case .success(let didSendMailOTP):
                guard didSendMailOTP else {
                    NSLog("[OnboardingTwoFactorAuthenticationPageViewModel] Failed sending mail OTP")
                    self?.isErrorAlertPresented = true
                    return
                }

                self?.textInputViewModel = .init(type: .biometryOTP) { [weak self] response in
                    if case .biometry(let otp) = response {
                        self?.requestTwoFactorAuthenticationWithBiometry(otp: otp)
                    }

                    self?.textInputViewModel = nil
                }

            case .failure(let error):
                NSLog("[OnboardingTwoFactorAuthenticationPageViewModel] Failed sending mail OTP with \(error)")
                self?.isErrorAlertPresented = true
            }
        }
    }
}
