import SwiftUI

class OnboardingPageViewModel: ObservableObject, Identifiable {
    let image: ImageResource
    let title: String
    let description: String
    @Published var pageActions: [OnboardingPageAction]
    @Published var isLoading: Bool = false
    @Published var isActionDisabled: Bool = false
    @Published var isErrorAlertPresented: Bool = false

    @Published var showAppView: Bool = false {
        didSet {
            guard oldValue && !showAppView else { return } // Has been dismissed
            didDismissAppView()
        }
    }

    var appUrlString: String = ""

    @Published var textInputViewModel: OnboardingTextInputViewModel?

    weak var onboardingViewModel: OnboardingViewModel?

    private(set) var rootView: (any View)?

    init(image: ImageResource,
         title: String,
         description: String,
         pageActions: [OnboardingPageAction] = []) {
        self.image = image
        self.title = title
        self.description = description
        self.pageActions = pageActions

        setupPageActions()
    }

    func setupPageActions() {}
    func checkPreconditions() {}
    func additionalContent() -> AnyView? { nil }

    func viewWillAppear(_ view: some View) {
        rootView = view
    }

    func didDismissAppView() {}

    func finishOnboardingPage() {
        onboardingViewModel?.nextPage()
    }
}
