import Foundation

public protocol TwoFactorAuthenticationRepository {
    func isBiometricAuthenticationSupported(_ completion: @escaping (Result<Bool, Error>) -> Void)

    func isBiometricAuthenticationEnabled(_ completion: @escaping (Result<Bool, Error>) -> Void)

    func isPinSet(_ completion: @escaping (Result<Bool, Error>) -> Void)

    func requestOneTimePassword(_ completion: @escaping (Result<Bool, Error>) -> Void)

    func enableBiometricAuthentication(otp: String?, _ completion: @escaping (Result<Bool, Error>) -> Void)

    func enablePinAuthentication(pin: String, otp: String, _ completion: @escaping (Result<Bool, Error>) -> Void)
}
