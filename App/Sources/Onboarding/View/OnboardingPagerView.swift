import SwiftUI

struct OnboardingPagerView: View {
    @Binding private var currentPageIndex: Int
    private let onboardingPageViewModels: [OnboardingPageViewModel]

    init(onboardingPageViewModels: [OnboardingPageViewModel], currentPageIndex: Binding<Int>) {
        self.onboardingPageViewModels = onboardingPageViewModels
        self._currentPageIndex = currentPageIndex
    }

    var body: some View {
        VStack {
            ForEach(0..<onboardingPageViewModels.count, id: \.self) { index in
                if index == currentPageIndex {
                    OnboardingPageView(viewModel: onboardingPageViewModels[index])
                        .padding(.bottom, .paddingM)
                        .pagingTransition()
                }
            }
        }
    }
}
