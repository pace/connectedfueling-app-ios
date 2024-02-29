import SwiftUI

struct LegalUpdatePagerView: View {
    @Binding private var currentPageIndex: Int
    private let legalUpdatePageViewModels: [LegalUpdatePageViewModel]

    init(legalUpdatePageViewModels: [LegalUpdatePageViewModel], currentPageIndex: Binding<Int>) {
        self.legalUpdatePageViewModels = legalUpdatePageViewModels
        self._currentPageIndex = currentPageIndex
    }

    var body: some View {
        VStack {
            ForEach(0..<legalUpdatePageViewModels.count, id: \.self) { index in
                if index == currentPageIndex {
                    LegalUpdatePageView(viewModel: legalUpdatePageViewModels[index])
                        .padding(.bottom, .paddingM)
                        .pagingTransition()
                }
            }
        }
    }
}
