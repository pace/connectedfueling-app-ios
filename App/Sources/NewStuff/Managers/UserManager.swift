import LocalAuthentication
import PACECloudSDK
import UIKit

struct UserManager {
    enum TwoFactorAuthenticationMethod: Equatable {
        case pin
        case biometry
    }

    func availableTwoFactorAuthenticationMethods() -> Set<TwoFactorAuthenticationMethod> {
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

    private var isBiometricAuthenticationEnabled: Bool {
        IDKit.isBiometricAuthenticationEnabled()
    }

    private var isBiometricAuthenticationSupported: Bool {
        let context = LAContext()
        var error: NSError?
        let isSupported = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        return isSupported
    }

    func authorize() async -> Result<String?, Error> {
        switch await IDKit.authorize() {
        case .success(let accessToken):
            return .success(accessToken)

        case .failure(let error):
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
