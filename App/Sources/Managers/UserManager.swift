import LocalAuthentication
import PACECloudSDK
import UIKit

struct UserManager {
    enum TwoFactorAuthenticationMethod: Equatable {
        case pin
        case biometry
    }

    var availableTwoFactorAuthenticationMethods: Set<TwoFactorAuthenticationMethod> {
        var methods: Set<TwoFactorAuthenticationMethod> = [.pin]

        if isBiometricAuthenticationSupported {
            methods.insert(.biometry)
        }

        return methods
    }

    func configuredTwoFactorAuthenticationMethods() async -> Set<TwoFactorAuthenticationMethod> {
        var methods: Set<TwoFactorAuthenticationMethod> = []

        if case .success(let isPINSet) = await isPINSet(), isPINSet {
            methods.insert(.pin)
        }

        if isBiometricAuthenticationEnabled {
            methods.insert(.biometry)
        }

        return methods
    }

    func isTwoFactorAuthenticationMethodConfigured(_ method: TwoFactorAuthenticationMethod) async -> Bool {
        let configuredMethods = await configuredTwoFactorAuthenticationMethods()
        return configuredMethods.contains(method)
    }
}

extension UserManager {
    var presentingViewController: UIViewController? {
        get { IDKit.presentingViewController }
        set { IDKit.presentingViewController = newValue }
    }

    var isAuthorizationValid: Bool {
        IDKit.isAuthorizationValid()
    }

    var latestAccessToken: String? {
        IDKit.latestAccessToken()
    }

    var email: String? {
        guard let currentAccessToken = latestAccessToken else { return nil }
        let tokenValidator = IDKit.TokenValidator(accessToken: currentAccessToken)
        return tokenValidator.jwtValue(for: Constants.jwtEmailKey) as? String
    }

    var isBiometricAuthenticationEnabled: Bool {
        IDKit.isBiometricAuthenticationEnabled()
    }

    var isBiometricAuthenticationSupported: Bool {
        let context = LAContext()
        var error: NSError?
        let isSupported = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        return isSupported
    }

    func disableBiometricAuthentication() {
        IDKit.disableBiometricAuthentication()
    }

    func authorize() async -> Result<String?, Error> {
        switch await IDKit.authorize() {
        case .success(let accessToken):
            return .success(accessToken)

        case .failure(let error):
            return .failure(error)
        }
    }

    @discardableResult
    func refresh() async -> Result<String?, Error> {
        switch await IDKit.refreshToken() {
        case .success(let accessToken):
            return .success(accessToken)

        case .failure(let error):
            CofuLogger.e("[UserManager] Failed token refresh with error \(error).")

            if case .failedTokenRefresh = error {
                reset()
            }

            return .failure(error)
        }
    }

    @discardableResult
    func logout() async -> Result<Void, Error> {
        defer {
            reset()
        }

        switch await IDKit.resetSession() {
        case .success:
            CofuLogger.i("[UserManager] Successfully logged out user")
            return .success(())

        case .failure(let error):
            CofuLogger.e("[UserManager] Failed ending remote session with \(error). User session will still be terminated.")
            return .failure(error)
        }
    }

    private func isPINSet() async -> Result<Bool, Error> {
        switch await IDKit.isPINSet() {
        case .success(let isPinSet):
            return .success(isPinSet)

        case .failure(let error):
            return .failure(error)
        }
    }

    func isPasswordSet() async -> Result<Bool, Error> {
        switch await IDKit.isPasswordSet() {
        case .success(let isPasswordSet):
            return .success(isPasswordSet)

        case .failure(let error):
            return .failure(error)
        }
    }

    func sendMailOTP() async -> Result<Bool, Error> {
        switch await IDKit.sendMailOTP() {
        case let .success(success):
            return .success(success)

        case let .failure(error):
            return .failure(error)
        }
    }

    func enableBiometricAuthentication(otp: String?) async -> Result<Bool, Error> {
        let result = if let otp = otp {
            await IDKit.enableBiometricAuthentication(otp: otp)
        } else {
            await IDKit.enableBiometricAuthentication()
        }

        switch result {
        case let .success(success):
            return .success(success)

        case let .failure(error):
            return .failure(error)
        }
    }

    func setPIN(pin: String, otp: String) async -> Result<Bool, Error> {
        switch await IDKit.setPIN(pin: pin, otp: otp) {
        case let .success(success):
            return .success(success)

        case let .failure(error):
            return .failure(error)
        }
    }
}

private extension UserManager {
    private func reset() {
        UserDefaults.isOnboardingCompleted = false
        UserDefaults.isAnalyticsAllowed = false
    }
}
