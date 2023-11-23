import SwiftUI

struct PaymentMethodsListItemView: View {
    @ObservedObject private var viewModel: PaymentMethodViewModel

    init(viewModel: PaymentMethodViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        HStack(spacing: 0) {
            paymentMethodIcon
                .frame(width: 30, height: 30)
                .padding(.trailing, 14)
            Button {
                viewModel.presentPaymentApp()
            } label: {
                VStack(alignment: .leading, spacing: 0) {
                    TextLabel(viewModel.localizedKind, textColor: .genericGrey)
                        .font(.system(size: 14))
                    TextLabel(viewModel.identification)
                        .font(.system(size: 16, weight: .medium))
                }
            }
            Spacer()
            DisclosureIndicator()
        }
    }

    @ViewBuilder
    private var paymentMethodIcon: some View {
        AsyncImage(url: URL(string: viewModel.paymentMethodIconUrlString)) { image in
            image.resizable()
        } placeholder: {
            Image.paymentMethodIcon
                .foregroundStyle(Color.genericGrey)
        }
    }
}

#Preview {
    VStack {
        PaymentMethodsListItemView(viewModel: .init(paymentMethod: .init(id: "",
                                                                         kind: "paypal",
                                                                         identificationString: "user@pace.car",
                                                                         alias: nil,
                                                                         iconUrlString: nil),
                                                    delegate: nil))
        PaymentMethodsListItemView(viewModel: .init(paymentMethod: .init(id: "",
                                                                         kind: "creditcard",
                                                                         identificationString: "user@pace.car",
                                                                         alias: nil,
                                                                         iconUrlString: nil),
                                                    delegate: nil))
        PaymentMethodsListItemView(viewModel: .init(paymentMethod: .init(id: "",
                                                                         kind: "applepay",
                                                                         identificationString: "user@pace.car",
                                                                         alias: "Alias", 
                                                                         iconUrlString: nil),
                                                    delegate: nil))
    }
}
