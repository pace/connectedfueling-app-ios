import SwiftUI

struct OnboardingView: View {
    @ObservedObject private var viewModel: OnboardingViewModel
    @State private var currentPage = 0

    init(viewModel: OnboardingViewModel) {
        self.viewModel = viewModel
        self.currentPage = currentPage
    }

    var body: some View {
        pageView
            .onAppear {
                viewModel.checkNextPreconditions()
            }
    }

    @ViewBuilder
    private var pageView: some View {
        PageView(numberOfPages: viewModel.pageViewModels.count, currentPage: $viewModel.currentPage) {
            ForEach(viewModel.pageViewModels) { viewModel in
                OnboardingPageView(viewModel: viewModel)
                    .padding(.bottom, 20)
            }
        }
        .overlay(PageIndicatorView(numberOfPages: viewModel.pageViewModels.count,
                                   selectedIndex: $viewModel.currentPage),
                 alignment: .bottom)
    }
}

#Preview {
    OnboardingView(viewModel: .init())
}
