import Foundation

class PaymentMethodViewModel: ObservableObject, Identifiable {
    @Published var paymentMethodUrlString: String?

    private let paymentMethod: PaymentMethod
    private let paymentManager: PaymentManager

    private weak var delegate: PaymentMethodsViewModel?

    init(paymentMethod: PaymentMethod,
         delegate: PaymentMethodsViewModel?,
         paymentManager: PaymentManager = .init()) {
        self.paymentMethod = paymentMethod
        self.delegate = delegate
        self.paymentManager = paymentManager
    }

    func presentPaymentApp() {
        delegate?.showPaymentMethodApp(for: paymentMethod.id, kind: kind)
    }
}

extension PaymentMethodViewModel {
    var kind: String {
        paymentMethod.kind
    }

    var localizedKind: String {
        let localizedKind = "payment_method_kind_\(kind)".localized
        return localizedKind == "payment_method_kind_\(kind)" ? kind : localizedKind
    }

    var identification: String {
        paymentMethod.alias ?? paymentMethod.identificationString
    }

    var paymentMethodIconUrlString: String {
        paymentMethod.iconUrlString ?? ""
    }
}
