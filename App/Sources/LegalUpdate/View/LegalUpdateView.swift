import SwiftUI

struct LegalUpdateView: View {
    @ObservedObject private var viewModel: LegalUpdateViewModel

    init(pages: LegalUpdateViewModel.LegalUpdatePages,
         analyticsManager: AnalyticsManager = .init(),
         dismissAction: @escaping () -> Void) {
        self.viewModel = .init(pages: pages, analyticsManager: analyticsManager)
        self.viewModel.dismiss = dismissAction
    }

    var body: some View {
        LegalUpdatePagerView(legalUpdatePageViewModels: viewModel.pageViewModels,
                            currentPageIndex: $viewModel.currentPage)
    }
}
