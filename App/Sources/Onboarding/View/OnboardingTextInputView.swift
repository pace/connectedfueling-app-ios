import SwiftUI

struct OnboardingTextInputView: View {
    private enum FocusedField: Hashable {
        case input
    }

    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var viewModel: OnboardingTextInputViewModel
    @State private var input: String = ""
    @State private var isNextPagePresented: Bool = false

    @FocusState private var focusedField: FocusedField?

    init(viewModel: OnboardingTextInputViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        content
            .alert(item: $viewModel.alert) { alert in
                alert
            }
            .onAppear {
                focusedField = .input
            }
            .onDisappear {
                focusedField = nil
            }
    }

    @ViewBuilder
    private var content: some View {
        VStack(spacing: 0) {
            TextLabel(viewModel.title, alignment: .center)
                .font(.system(size: 20, weight: .semibold))
                .padding(.horizontal, Constants.View.defaultTitleLabelPadding)
                .padding(.top, .paddingXL)
            TextLabel(viewModel.description, alignment: .center)
                .font(.system(size: 16, weight: .regular))
                .padding(.horizontal, Constants.View.defaultDescriptionLabelPadding)
                .padding(.top, .paddingXXL)
            TextInputField(isSecure: viewModel.isInputSecure, text: $input)
                .onChange(of: input) { newInput in
                    viewModel.onEditingChanged(of: newInput)
                }
                .focused($focusedField, equals: .input)
                .keyboardType(.numberPad)
                .padding(.top, .paddingM)
            TextLabel(viewModel.warningText, textColor: .genericRed)
                .font(.system(size: 12, weight: .regular))
                .padding(.horizontal, Constants.View.defaultTitleLabelPadding)
                .padding(.top, .paddingXS)
            ActionButton(title: viewModel.actionTitle,
                         isDisabled: $viewModel.isActionDisabled) {
                viewModel.didTapActionButton(textInput: input)
            }
                         .padding(.top, .paddingXL)
                         .padding(.horizontal, .paddingM)
            navigationLink
            Spacer()
        }
    }

    @ViewBuilder
    private var navigationLink: some View {
        if let nextTextInputViewModel = viewModel.nextTextInputViewModel {
            NavigationLink(isActive: $viewModel.isNextTextInputViewPresented) {
                OnboardingTextInputView(viewModel: nextTextInputViewModel)
            } label: {
                EmptyView()
            }
        } else {
            EmptyView()
        }
    }
}

#Preview {
    AppNavigationView {
        OnboardingTextInputView(viewModel: .init(type: .pin, completion: { _ in }))
            .addNavigationBar(style: .standard(title: nil))
    }
}
