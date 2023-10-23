import SwiftUI

struct OnboardingPageView: View {
    @ObservedObject private var viewModel: OnboardingPageViewModel

    init(viewModel: OnboardingPageViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        pageView
            .onAppear {
                viewModel.viewWillAppear(self)
            }
            .sheet(isPresented: $viewModel.showAppView) {
                AppView(urlString: viewModel.appUrlString)
            }
            .sheet(item: $viewModel.textInputViewModel) { textInputViewModel in
                AppNavigationView {
                    OnboardingTextInputView(viewModel: textInputViewModel)
                        .addNavigationBar(showsLogo: false)
                }
            }
            .alert(isPresented: $viewModel.isErrorAlertPresented) {
                Alert(title: Text("Oops, something went wrong"),
                      message: Text("Please try again"))
            }
    }

    @ViewBuilder
    private var pageView: some View {
        VStack(spacing: 0) {
            ScrollView {
                pageContent
            }
            Spacer()
            actionButtons
        }
    }

    @ViewBuilder
    var pageContent: some View {
        VStack(spacing: 0) {
            Image(viewModel.image)
                .frame(width: 100, height: 100, alignment: .center)
                .padding(.top, 100)
            VStack(spacing: 0) {
                TextLabel(viewModel.title, alignment: .center)
                    .font(.system(size: 20, weight: .semibold))
                    .padding(.top, 40)
                    .padding(.horizontal, Constants.View.defaultTitleLabelPadding)
                TextLabel(viewModel.description, alignment: .center)
                    .font(.system(size: 16, weight: .regular))
                    .padding(.top, 14)
                    .padding(.horizontal, Constants.View.defaultDescriptionLabelPadding)
            }
            if viewModel.isLoading {
                LoadingView()
                    .padding(.top, 40)
            }
            viewModel.additionalContent()
        }
    }

    @ViewBuilder
    var actionButtons: some View {
        ForEach(viewModel.pageActions.reversed()) { pageAction in
            ActionButton(title: pageAction.title,
                         style: pageAction == viewModel.pageActions.first ? .primary : .secondary,
                         isDisabled: $viewModel.isActionDisabled,
                         action: pageAction.action)
        }
    }
}

#Preview {
    OnboardingPageView(viewModel: .init(image: .biometry,
                                        title: "Test Title",
                                        description: "Test Description",
                                        pageActions: [
                                            .init(title: "Test Action", action: {})
                                        ]))
}
