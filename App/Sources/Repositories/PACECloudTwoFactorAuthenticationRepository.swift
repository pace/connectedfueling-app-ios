import Domain
import LocalAuthentication
import PACECloudSDK
import UIKit

struct PACECloudTwoFactorAuthenticationRepository: TwoFactorAuthenticationRepository {
    func isBiometricAuthenticationSupported(_ completion: @escaping (Result<Bool, Error>) -> Void) {
        let context = LAContext()
        var error: NSError?
        let isSupported = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        completion(.success(isSupported))
    }

    func isBiometricAuthenticationEnabled(_ completion: @escaping (Result<Bool, Error>) -> Void) {
        completion(.success(IDKit.isBiometricAuthenticationEnabled()))
    }

    func isPinSet(_ completion: @escaping (Result<Bool, Error>) -> Void) {
        IDKit.isPINSet { result in
            switch result {
            case let .success(isSet):
                completion(.success(isSet))

            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    func isPasswordSet(_ completion: @escaping (Result<Bool, Error>) -> Void) {
        IDKit.isPasswordSet { result in
            switch result {
            case let .success(isSet):
                completion(.success(isSet))

            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    func requestOneTimePassword(_ completion: @escaping (Result<Bool, Error>) -> Void) {
        IDKit.sendMailOTP { result in
            switch result {
            case let .success(success):
                completion(.success(success))

            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    func enableBiometricAuthentication(otp: String?, _ completion: @escaping (Result<Bool, Error>) -> Void) {
        let responseHandler: (Result<Bool, IDKit.IDKitError>) -> Void = { result in
            switch result {
            case let .success(success):
                completion(.success(success))

            case let .failure(error):
                completion(.failure(error))
            }
        }

        if let otp = otp {
            IDKit.enableBiometricAuthentication(otp: otp, completion: responseHandler)
        } else {
            IDKit.enableBiometricAuthentication(completion: responseHandler)
        }
    }

    func enablePinAuthentication(pin: String, otp: String, _ completion: @escaping (Result<Bool, Error>) -> Void) {
        IDKit.setPIN(pin: pin, otp: otp) { result in
            switch result {
            case let .success(success):
                completion(.success(success))

            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
