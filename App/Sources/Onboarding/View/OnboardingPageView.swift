import SwiftUI

struct OnboardingPageView: View {
    @ObservedObject private var viewModel: OnboardingPageViewModel

    private let primaryHeaderIconSize: CGFloat = 68

    init(viewModel: OnboardingPageViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        content
            .onAppear {
                viewModel.viewWillAppear(self)
            }
            .sheet(item: $viewModel.appUrlString) { appUrlString in
                AppView(urlString: appUrlString,
                        completion: viewModel.didDismissAppView)
            }
            .sheet(item: $viewModel.webView) { webView in
                webView
            }
            .sheet(item: $viewModel.textInputViewModel) { textInputViewModel in
                AppNavigationView {
                    OnboardingTextInputView(viewModel: textInputViewModel)
                        .addNavigationBar(style: .standard(title: nil))
                }
            }
            .alert(item: $viewModel.alert) { alert in
                alert
            }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.style {
        case .primary:
            pageView
                .edgesIgnoringSafeArea(.top)

        case .secondary:
            pageView
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
    private var pageContent: some View {
        VStack(spacing: 0) {
            headerContent
            VStack(spacing: 0) {
                TextLabel(viewModel.title, alignment: .center)
                    .font(.system(size: 20, weight: .bold))
                    .padding(.top, .paddingL)
                    .padding(.horizontal, .paddingM)
                TextLabel(viewModel.description, alignment: .center)
                    .font(.system(size: 16, weight: .regular))
                    .padding([.horizontal, .top], .paddingM)
            }
            .environment(\.openURL, OpenURLAction(handler: viewModel.handleLinks))
            if viewModel.isLoading {
                LoadingSpinner()
                    .padding(.top, 40)
            }
            viewModel.additionalContent()
        }
    }

    @ViewBuilder
    private var headerContent: some View {
        switch viewModel.style {
        case .primary:
            Image(.onboardingPrimaryHeaderIcon)
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, minHeight: 400)
            ZStack {
                Circle()
                    .frame(width: primaryHeaderIconSize, height: primaryHeaderIconSize)
                    .foregroundStyle(Color.genericWhite)
                viewModel.image
                    .resizable()
                    .frame(width: 42, height: 42)
                    .foregroundColor(Color.primaryTint)
            }
            .padding(.top, -primaryHeaderIconSize / 2)

        case .secondary:
            viewModel.image
                .resizable()
                .frame(width: 182, height: 182)
                .foregroundColor(Color.lightGrey)
                .padding(.top, 165)
        }
    }

    @ViewBuilder
    private var actionButtons: some View {
        VStack(spacing: .paddingXS) {
            ForEach(viewModel.pageActions.reversed()) { pageAction in
                ActionButton(title: pageAction.title,
                             style: pageAction == viewModel.pageActions.first ? .primary : .secondary,
                             isLoading: $viewModel.isActionLoading,
                             isDisabled: $viewModel.isActionDisabled,
                             action: pageAction.action)
                .padding(.horizontal, .paddingM)
            }
        }
    }
}

#Preview {
    AppNavigationView {
        OnboardingPageView(viewModel: .init(style: .primary,
                                            image: .onboardingBiometryIcon,
                                            title: "Test Title",
                                            description: "Test Description",
                                            pageActions: [
                                                .init(title: "Test Action", action: {})
                                            ]))
    }
}

#Preview {
    AppNavigationView {
        OnboardingPageView(viewModel: .init(style: .secondary,
                                            image: .onboardingBiometryIcon,
                                            title: "Test Title",
                                            description: "Test Description",
                                            pageActions: [
                                                .init(title: "Test Action", action: {})
                                            ]))
        .addNavigationBar(style: .centeredIcon(icon: .secondaryHeaderIcon))
    }
}
