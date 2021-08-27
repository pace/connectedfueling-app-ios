import Foundation

public final class TwoFactorAuthenticationInteractor {
    private let twoFactorAuthenticationRepository: TwoFactorAuthenticationRepository

    public init(twoFactorAuthenticationRepository: TwoFactorAuthenticationRepository) {
        self.twoFactorAuthenticationRepository = twoFactorAuthenticationRepository
    }

    public func getAvailableAuthenticationMethods(
        _ completion: @escaping (Result<Set<TwoFactorAuthenticationMethod>, Error>) -> Void
    ) {
        var methods: Set<TwoFactorAuthenticationMethod> = [.pin]

        twoFactorAuthenticationRepository.isBiometricAuthenticationSupported { result in
            if case .success(true) = result {
                methods.insert(.biometry)
            }

            completion(.success(methods))
        }
    }

    public func getConfiguredAuthenticationMethods(
        _ completion: @escaping (Result<Set<TwoFactorAuthenticationMethod>, Error>) -> Void
    ) {
        twoFactorAuthenticationRepository.isPinSet { [weak self] result in
            switch result {
            case let .success(isSet):
                var methods: Set<TwoFactorAuthenticationMethod> = []
                if isSet {
                    methods.insert(.pin)
                }

                self?.getConfiguredAuthenticationMethodsAppendingBiometry(into: methods, completion)

            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    private func getConfiguredAuthenticationMethodsAppendingBiometry(
        into methods: Set<TwoFactorAuthenticationMethod>,
        _ completion: @escaping (Result<Set<TwoFactorAuthenticationMethod>, Error>) -> Void
    ) {
        twoFactorAuthenticationRepository.isBiometricAuthenticationEnabled { result in
            switch result {
            case let .success(isSet):
                var methods = methods
                if isSet {
                    methods.insert(.biometry)
                }

                completion(.success(methods))

            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    public func isAuthenticationMethodConfigured(
        _ method: TwoFactorAuthenticationMethod,
        _ completion: @escaping (Result<Bool, Error>) -> Void
    ) {
        switch method {
        case .pin:
            twoFactorAuthenticationRepository.isPinSet(completion)

        case .biometry:
            twoFactorAuthenticationRepository.isBiometricAuthenticationEnabled(completion)
        }
    }

    public func requestOneTimePassword(_ completion: @escaping (Result<Bool, Error>) -> Void) {
        twoFactorAuthenticationRepository.requestOneTimePassword(completion)
    }

    public func enableBiometricAuthentication(otp: String?, _ completion: @escaping (Result<Bool, Error>) -> Void) {
        twoFactorAuthenticationRepository.enableBiometricAuthentication(otp: otp, completion)
    }

    public func enablePinAuthentication(pin: String, otp: String, _ completion: @escaping (Result<Bool, Error>) -> Void) {
        twoFactorAuthenticationRepository.enablePinAuthentication(pin: pin, otp: otp, completion)
    }
}
