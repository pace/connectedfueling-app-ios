import SwiftUI

class OnboardingPageViewModel: ObservableObject, Identifiable {
    let style: ConfigurationManager.Configuration.OnboardingStyle
    let image: Image
    let title: String
    let description: String

    var isCheckingNextPages: Bool = false {
        didSet {
            isActionDisabled = isCheckingNextPages
            isActionLoading = isCheckingNextPages
        }
    }

    @Published var pageActions: [OnboardingPageAction]
    @Published var isLoading: Bool = false
    @Published var isActionDisabled: Bool = false
    @Published var isActionLoading: Bool = false

    @Published var webView: WebView?
    @Published var textInputViewModel: OnboardingTextInputViewModel?
    @Published var appUrlString: String?

    @Published var alert: Alert?

    weak var onboardingViewModel: OnboardingViewModel?

    private(set) var rootView: (any View)?

    init(style: ConfigurationManager.Configuration.OnboardingStyle,
         image: Image,
         title: String,
         description: String,
         pageActions: [OnboardingPageAction] = []) {
        self.style = style
        self.image = image.renderingMode(.template)
        self.title = title
        self.description = description
        self.pageActions = pageActions

        setupPageActions()
    }

    func setupPageActions() {}
    func isPageAlreadyCompleted() async -> Bool { false }
    func additionalContent() -> AnyView? { nil }
    func handleLinks(_ url: URL) -> OpenURLAction.Result { .discarded }

    func viewWillAppear(_ view: some View) {
        rootView = view
    }

    func didDismissAppView() {}

    func finishOnboardingPage() {
        onboardingViewModel?.nextPage()
    }
}
