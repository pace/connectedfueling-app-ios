import SwiftUI

class ConsentUpdatePageViewModel: ObservableObject, Identifiable {
    let title: String
    let description: String

    @Published var pageActions: [OnboardingPageAction]

    @Published var webView: WebView?

    weak var consentUpdateViewModel: ConsentUpdateViewModel?

    private(set) var rootView: (any View)?

    init(title: String,
         description: String,
         pageActions: [OnboardingPageAction] = []) {
        self.title = title
        self.description = description
        self.pageActions = pageActions

        setupPageActions()
    }

    func setupPageActions() {}
    func handleLinks(_ url: URL) -> OpenURLAction.Result { .discarded }

    func viewWillAppear(_ view: some View) {
        rootView = view
    }

    func finishConsentUpdatePage() {
        consentUpdateViewModel?.nextPage()
    }
}
