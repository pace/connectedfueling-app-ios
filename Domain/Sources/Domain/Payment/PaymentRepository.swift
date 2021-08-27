import Foundation

public protocol PaymentRepository {
    func hasPaymentMethods(_ completion: @escaping (Result<Bool, Error>) -> Void)
}
