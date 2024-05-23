import SwiftUI

struct ConsentUpdateView: View {
    @StateObject private var viewModel: ConsentUpdateViewModel
    @State private var dismissAction: () -> Void

    init(pages: ConsentUpdateViewModel.ConsentUpdatePages,
         analyticsManager: AnalyticsManager = .init(),
         dismissAction: @escaping () -> Void) {
        self._viewModel = .init(wrappedValue: .init(pages: pages, analyticsManager: analyticsManager))
        self.dismissAction = dismissAction
    }

    var body: some View {
        ConsentUpdatePagerView(consentUpdatePageViewModels: viewModel.pageViewModels,
                            currentPageIndex: $viewModel.currentPage)
        .onAppear {
            viewModel.dismiss = dismissAction
        }
    }
}
