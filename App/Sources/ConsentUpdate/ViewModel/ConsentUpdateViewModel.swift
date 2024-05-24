import SwiftUI

class ConsentUpdateViewModel: ObservableObject {

    struct ConsentUpdatePages: OptionSet, Identifiable {
        let id: Int
        let rawValue: UInt

        init(rawValue: UInt) {
            self.id = Int(rawValue)
            self.rawValue = rawValue
        }

        static let terms = ConsentUpdatePages(rawValue: 1 << 0)
        static let dataPrivacy = ConsentUpdatePages(rawValue: 1 << 1)
        static let tracking = ConsentUpdatePages(rawValue: 1 << 2)
        static let notifications = ConsentUpdatePages(rawValue: 1 << 3)
    }

    @Published var currentPage: Int = 0

    var pageViewModels: [ConsentUpdatePageViewModel]
    var dismiss: (() -> Void)?

    init(pages: ConsentUpdatePages,
         analyticsManager: AnalyticsManager = .init()) {
        var viewModels: [ConsentUpdatePageViewModel] = []

        if pages.contains(.terms) {
            viewModels.append(TermsUpdatePageViewModel())
        }

        if pages.contains(.dataPrivacy) {
            viewModels.append(DataPrivacyUpdatePageViewModel())
        }

        if pages.contains(.tracking) {
            viewModels.append(TrackingUpdatePageViewModel(analyticsManager: analyticsManager))
        }

        if pages.contains(.notifications) {
            viewModels.append(NotificationConsentPageViewModel())
        }

        pageViewModels = viewModels

        setupDelegates()
    }

    private func setupDelegates() {
        pageViewModels.forEach {
            $0.consentUpdateViewModel = self
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
