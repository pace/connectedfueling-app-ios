import PassKit

extension PKPaymentNetwork {
    // TODO: - Define supported payment networks
    static var supportedPaymentNetworks: [PKPaymentNetwork] {
        [.visa, .masterCard, .maestro, .girocard]
    }
}
