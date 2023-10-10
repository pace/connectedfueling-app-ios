import Foundation
import PACECloudSDK

struct PaymentManager {
    func hasPaymentMethods() async -> Result<Bool, Error> {
        let request = PayAPI.PaymentMethods.GetPaymentMethodsIncludingCreditCheck.Request(filterstatus: .valid)
        let response = await API.Pay.client.makeRequest(request)

        switch response.result {
        case .success(let result):
            let hasPaymentMethods = result.successful && !(result.success?.data?.isEmpty ?? true)
            return .success(hasPaymentMethods)

        case let .failure(error):
            return .failure(error)
        }
    }
}
