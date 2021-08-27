import Foundation

public final class PaymentInteractor {
    private let paymentRepository: PaymentRepository

    public init(paymentRepository: PaymentRepository) {
        self.paymentRepository = paymentRepository
    }

    public func hasPaymentMethods(_ completion: @escaping (Result<Bool, Error>) -> Void) {
        paymentRepository.hasPaymentMethods(completion)
    }
}
