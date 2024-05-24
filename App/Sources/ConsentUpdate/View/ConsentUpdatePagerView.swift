import SwiftUI

struct ConsentUpdatePagerView: View {
    @Binding private var currentPageIndex: Int
    private let consentUpdatePageViewModels: [ConsentUpdatePageViewModel]

    init(consentUpdatePageViewModels: [ConsentUpdatePageViewModel], currentPageIndex: Binding<Int>) {
        self.consentUpdatePageViewModels = consentUpdatePageViewModels
        self._currentPageIndex = currentPageIndex
    }

    var body: some View {
        VStack {
            ForEach(0..<consentUpdatePageViewModels.count, id: \.self) { index in
                if index == currentPageIndex {
                    ConsentUpdatePageView(viewModel: consentUpdatePageViewModels[index])
                        .padding(.bottom, .paddingM)
                        .pagingTransition()
                }
            }
        }
    }
}
