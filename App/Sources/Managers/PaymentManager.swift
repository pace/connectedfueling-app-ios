import Foundation
import PACECloudSDK
import PassKit

struct PaymentManager {
    var isApplePaySetUp: Bool {
        PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: PKPaymentNetwork.supportedPaymentNetworks)
    }

    var paymentAppUrlString: String {
        PACECloudSDK.URL.payment.absoluteString
    }

    func paymentMethodUrlString(for id: String, kind: String) -> String {
        let paymentMethodId = kind == Constants.applePayKind ? Constants.applePayKind : "\(id)"
        let urlString = "\(PACECloudSDK.URL.payment.absoluteString)/payment-method/\(paymentMethodId)?redirect_uri=\(AppKit.Constants.appCloseRedirectUri)"
        return urlString
    }

    func hasPaymentMethods() async -> Result<Bool, Error> {
        let result = await paymentMethods()

        switch result {
        case .success(let paymentMethods):
            let hasPaymentMethods = !paymentMethods.isEmpty || isApplePaySetUp
            return .success(hasPaymentMethods)

        case let .failure(error):
            return .failure(error)
        }
    }

    func paymentMethods() async -> Result<[PaymentMethod], Error> {
        let request = PayAPI.PaymentMethods.GetPaymentMethodsIncludingCreditCheck.Request(filterstatus: .valid)
        let response = await API.Pay.client.makeRequest(request)

        switch response.result {
        case .success(let result):
            guard let apiPaymentMethods = result.success?.data else {
                return .failure(APIClientError.invalidDataError)
            }

            var paymentMethods: [PaymentMethod] = apiPaymentMethods.compactMap {
                guard let id = $0.id,
                      let kind = $0.kind,
                      let identificationString = $0.identificationString
                else { return nil }

                let iconUrlString = $0.paymentMethodVendor?.logo?.href.flatMap { paymentMethodIconCDNUrlString(href: $0) }

                return .init(id: id,
                             kind: kind,
                             identificationString: identificationString,
                             alias: $0.alias,
                             iconUrlString: iconUrlString)
            }

            if !paymentMethods.contains(where: { $0.kind == Constants.applePayKind }),
               isApplePaySetUp {
                let applePay: PaymentMethod = .init(id: Constants.applePayKind,
                                                    kind: Constants.applePayKind,
                                                    identificationString: L10n.paymentMethodKindApplepay,
                                                    alias: nil,
                                                    iconUrlString: nil) // TODO: - Icon url?
                paymentMethods.append(applePay)
            }

            return .success(paymentMethods)

        case let .failure(error):
            return .failure(error)
        }
    }

    func is2FANeededForPayments() async -> Bool {
        let result = await paymentMethodKinds()

        switch result {
        case .success(let paymentMethodKinds):
            let is2FANeeded = paymentMethodKinds.contains(where: { $0.twoFactor == true })
            UserDefaults.is2FANeededForPayments = is2FANeeded
            return is2FANeeded

        case .failure(let error):
            CofuLogger.e("[PaymentManager] Failed checking if 2FA is needed for payments with error \(error)")

            // Set `is2FANeededForPayments` to true for the setup to be shown in the wallet in case we couldn't fetch the actual value
            UserDefaults.is2FANeededForPayments = true

            return false
        }
    }

    func isNativePaymentMethodOnboardingEnabled() async -> Bool {
        let result = await paymentMethodKinds()

        switch result {
        case .success(let paymentMethodKinds):
            let isNativePaymentMethodOnboardingEnabled = paymentMethodKinds.contains(where: { !($0.implicit ?? false) })
            UserDefaults.isNativePaymentMethodOnboardingEnabled = isNativePaymentMethodOnboardingEnabled
            return isNativePaymentMethodOnboardingEnabled

        case .failure(let error):
            CofuLogger.e("[PaymentManager] Failed checking if native payment method onboarding is enabled with error \(error)")

            // Set `isNativePaymentMethodOnboardingEnabled` to true for the setup to be shown in the wallet in case we couldn't fetch the actual value
            UserDefaults.isNativePaymentMethodOnboardingEnabled = true

            return false
        }
    }

    private func paymentMethodKinds() async -> Result<PCPayPaymentMethodKinds, APIClientError> {
        let request = PayAPI.PaymentMethodKinds.GetPaymentMethodKinds.Request(additionalData: true)
        let response = await API.Pay.client.makeRequest(request)

        switch response.result {
        case .success(let result):
            guard let paymentMethodKinds = result.success?.data else {
                CofuLogger.e("[PaymentManager] Failed fetching payment method kinds. Invalid data.")
                return .failure(.invalidDataError)
            }

            return .success(paymentMethodKinds)

        case .failure(let error):
            CofuLogger.e("[PaymentManager] Failed fetching payment method kinds with error \(error)")
            return .failure(error)
        }
    }

    private func paymentMethodIconCDNUrlString(href: String) -> String? {
        guard let url = URL(string: href),
              let cdnBaseURL = URL(string: API.CDN.client.baseURL)
        else { return nil }

        if url.absoluteString.contains("cms/images") {
            // Contains cms prefix
            return cdnBaseURL
                .appendingPathComponent("pay")
                .appendingPathComponent("payment-method-vendors")
                .appendingPathComponent(url.lastPathComponent)
                .absoluteString
        } else if url.host != nil {
            // Absolute path
            return url.absoluteString
        } else if let relativeURL = URL(string: href, relativeTo: cdnBaseURL) {
            // Relative path
            return cdnBaseURL
                .appendingPathComponent(relativeURL.relativeString)
                .absoluteString
        } else {
            return nil
        }
    }
}
