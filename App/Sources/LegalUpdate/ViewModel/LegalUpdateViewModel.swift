import SwiftUI

class LegalUpdateViewModel: ObservableObject {

    struct LegalUpdatePages: OptionSet, Identifiable {
        let id: Int
        let rawValue: UInt

        init(rawValue: UInt) {
            self.id = Int(rawValue)
            self.rawValue = rawValue
        }

        static let terms = LegalUpdatePages(rawValue: 1 << 0)
        static let dataPrivacy = LegalUpdatePages(rawValue: 1 << 1)
        static let tracking = LegalUpdatePages(rawValue: 1 << 2)
    }

    @Published var currentPage: Int = 0

    var pageViewModels: [LegalUpdatePageViewModel]
    var dismiss: (() -> Void)?

    init(pages: LegalUpdatePages,
         analyticsManager: AnalyticsManager = .init()) {
        var viewModels: [LegalUpdatePageViewModel] = []

        if pages.contains(.terms) {
            viewModels.append(TermsUpdatePageViewModel())
        }

        if pages.contains(.dataPrivacy) {
            viewModels.append(DataPrivacyUpdatePageViewModel())
        }

        if pages.contains(.tracking) {
            viewModels.append(TrackingUpdatePageViewModel(analyticsManager: analyticsManager))
        }

        pageViewModels = viewModels

        setupDelegates()
    }

    private func setupDelegates() {
        pageViewModels.forEach {
            $0.legalUpdateViewModel = self
        }
    }

    private func nextIncompletePage(page: Int) -> Int? {
        guard pageViewModels[safe: page] != nil else { return nil }
        return page
    }

    func nextPage() {
        let nextIncompletePage = self.nextIncompletePage(page: self.currentPage + 1)

        if let nextIncompletePage {
            self.currentPage = nextIncompletePage
        } else {
            dismiss?()
        }
    }
}
