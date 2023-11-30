import Combine
import SwiftUI

class TwoFactorAuthenticationViewModel: ObservableObject {
    @Published var alert: Alert?
    @Published var inputViewModel: OnboardingTextInputViewModel?

    let initialIsBiometryAuthenticationEnabled: Bool

    var isBiometricAuthenticationSupported: Bool {
        userManager.isBiometricAuthenticationSupported
    }

    private let userManager: UserManager

    init(userManager: UserManager = .init()) {
        self.userManager = userManager
        self.initialIsBiometryAuthenticationEnabled = userManager.isBiometricAuthenticationEnabled
    }

    private func setPIN(_ pin: String, otp: String) {
        Task { @MainActor [weak self] in
            guard let result = await self?.userManager.setPIN(pin: pin, otp: otp) else { return }

            switch result {
            case .success(let didSetPIN):
                guard didSetPIN else {
                    NSLog("[TwoFactorAuthenticationViewModel] Failed setting PIN")
                    self?.alert = AppAlert.genericError
                    return
                }

                self?.alert = AppAlert.confirmation(title: L10n.walletTwoFactorAuthenticationPinSetupSuccessful)

            case .failure(let error):
                NSLog("[TwoFactorAuthenticationViewModel] Failed setting pin with \(error)")
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
                NSLog("[TwoFactorAuthenticationViewModel] Failed sending mail OTP")
                alert = AppAlert.genericError
                return false
            }

            return true

        case .failure(let error):
            NSLog("[TwoFactorAuthenticationViewModel] Failed sending mail OTP with \(error)")
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
                NSLog("[TwoFactorAuthenticationViewModel] Failed enabling biometric authentication")
                alert = AppAlert.genericError
                return false
            }

            alert = AppAlert.confirmation(title: L10n.walletTwoFactorAuthenticationBiometrySetupSuccessful)
            return true

        case .failure(let error):
            NSLog("[TwoFactorAuthenticationViewModel] Failed enabling biometric authentication with error \(error)")
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

    @MainActor
    func didTapBiometricAuthenticationToggle(newValue: Bool) async -> Bool {
        guard newValue != userManager.isBiometricAuthenticationEnabled else { return newValue }

        if newValue {
            guard await requestMailOTPForBiometry() else { return false }

            return await withCheckedContinuation { [weak self] continuation in
                self?.inputViewModel = .init(type: .biometryOTP) { [weak self] response in
                    if case .biometry(let otp) = response {
                        Task { @MainActor [weak self] in
                            let isSuccessful = await self?.requestTwoFactorAuthenticationWithBiometry(otp: otp) ?? false
                            continuation.resume(returning: isSuccessful)
                        }
                    } else {
                        continuation.resume(returning: false)
                    }

                    self?.inputViewModel = nil
                }
            }
        } else {
            return await withCheckedContinuation { [weak self] continuation in
                self?.alert = AppAlert.disabledBiometricAuthentication(disableAction: { [weak self] in
                    self?.userManager.disableBiometricAuthentication()
                    continuation.resume(returning: false)
                }, cancelAction: {
                    continuation.resume(returning: true)
                })
            }
        }
    }
}
