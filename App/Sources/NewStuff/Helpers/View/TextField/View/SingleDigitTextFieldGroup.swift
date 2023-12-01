import SwiftUI

struct SingleDigitTextFieldGroup: View {
    @ObservedObject var viewModel: SingleDigitTextFieldGroupViewModel

    init(viewModel: SingleDigitTextFieldGroupViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        HStack(spacing: .paddingXXS) {
            ForEach(0..<viewModel.numberOfDigits, id: \.self) { index in
                SingleDigitTextField(textFieldIndex: index,
                                     numberOfDigits: viewModel.numberOfDigits,
                                     selectedTextFieldIndex: $viewModel.selectedTextFieldIndex,
                                     text: $viewModel.inputs[index])
                .frame(width: 50, height: 50)
                .font(.system(size: 20))
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.genericBlack)
                .background(Color.genericWhite)
                .tint(.genericBlack)
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
                .overlay(
                    RoundedRectangle(cornerRadius: .cornerRadius)
                        .stroke(borderColor(for: index), lineWidth: 1)
                )
            }
        }
    }

    private func borderColor(for index: Int) -> Color {
        index == viewModel.selectedTextFieldIndex ? Color.primaryTint : .genericGrey
    }
}

#Preview {
    SingleDigitTextFieldGroup(viewModel: .init(numberOfDigits: 6))
}
