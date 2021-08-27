import Domain
import PACECloudSDK

struct PACECloudPaymentRepository: PaymentRepository {
    func hasPaymentMethods(_ completion: @escaping (Result<Bool, Error>) -> Void) {
        let request = PayAPI.PaymentMethods.GetPaymentMethodsIncludingCreditCheck.Request(filterstatus: .valid)
        API.Pay.client.makeRequest(request) { response in
            switch response.result {
            case let .success(result):
                let hasPaymentMethods = result.successful && !(result.success?.data?.isEmpty ?? true)
                completion(.success(hasPaymentMethods))

            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
