import Combine
import SwiftUI

class TwoFactorAuthenticationViewModel: ObservableObject {
    @Published var alert: Alert?
    @Published var inputViewModel: OnboardingTextInputViewModel?
    @Published var isBiometricAuthenticationEnabled: Bool

    var isBiometricAuthenticationSupported: Bool {
        userManager.isBiometricAuthenticationSupported
    }

    private let userManager: UserManager

    init(userManager: UserManager = .init()) {
        self.userManager = userManager
        self.isBiometricAuthenticationEnabled = userManager.isBiometricAuthenticationEnabled
    }

    private func refreshBiometryStatus() {
        isBiometricAuthenticationEnabled = userManager.isBiometricAuthenticationEnabled
    }

    private func setPIN(_ pin: String, otp: String) {
        Task { @MainActor [weak self] in
            guard let result = await self?.userManager.setPIN(pin: pin, otp: otp) else { return }

            switch result {
            case .success(let didSetPIN):
                guard didSetPIN else {
                    CofuLogger.e("[TwoFactorAuthenticationViewModel] Failed setting PIN")
                    self?.alert = AppAlert.genericError
                    return
                }

                self?.alert = AppAlert.confirmation(title: L10n.walletTwoFactorAuthenticationPinSetupSuccessful)

            case .failure(let error):
                CofuLogger.e("[TwoFactorAuthenticationViewModel] Failed setting pin with \(error)")
                self?.alert = AppAlert.genericError
            }
        }
    }

    @MainActor
    private func requestMailOTPForBiometry() async -> Bool {
        let result = await userManager.sendMailOTP()

        switch result {
        case .success(let didSendMailOTP):
            guard didSendMailOTP else {
                CofuLogger.e("[TwoFactorAuthenticationViewModel] Failed sending mail OTP")
                alert = AppAlert.genericError
                return false
            }

            return true

        case .failure(let error):
            CofuLogger.e("[TwoFactorAuthenticationViewModel] Failed sending mail OTP with \(error)")
            alert = AppAlert.genericError
            return false
        }
    }

    @MainActor
    private func requestTwoFactorAuthenticationWithBiometry(otp: String) async -> Bool {
        let result = await userManager.enableBiometricAuthentication(otp: otp)

        switch result {
        case .success(let isEnabled):
            guard isEnabled else {
                CofuLogger.e("[TwoFactorAuthenticationViewModel] Failed enabling biometric authentication")
                alert = AppAlert.genericError
                return false
            }

            alert = AppAlert.confirmation(title: L10n.walletTwoFactorAuthenticationBiometrySetupSuccessful)
            return true

        case .failure(let error):
            CofuLogger.e("[TwoFactorAuthenticationViewModel] Failed enabling biometric authentication with error \(error)")
            alert = AppAlert.genericError
            return false
        }
    }

    func presentPINSetup() {
        inputViewModel = .init(type: .pin) { [weak self] response in
            if case .pin(let pin, let otp) = response {
                self?.setPIN(pin, otp: otp)
            }

            self?.inputViewModel = nil
        }
    }

    func didTapBiometricAuthenticationToggle(newValue: Bool) {
        guard newValue != isBiometricAuthenticationEnabled else { return }

        if newValue {
            Task { @MainActor [weak self] in
                guard await self?.requestMailOTPForBiometry() == true else { return }

                self?.inputViewModel = .init(type: .biometryOTP) { [weak self] response in
                    if case .biometry(let otp) = response {
                        Task { @MainActor [weak self] in
                            let isSuccessful = await self?.requestTwoFactorAuthenticationWithBiometry(otp: otp) ?? false
                            self?.refreshBiometryStatus()
                        }
                    } else {
                        self?.refreshBiometryStatus()
                    }

                    self?.inputViewModel = nil
                }
            }
        } else {
            alert = AppAlert.disabledBiometricAuthentication(disableAction: { [weak self] in
                self?.userManager.disableBiometricAuthentication()
                self?.refreshBiometryStatus()
            }, cancelAction: {})
        }
    }
}
