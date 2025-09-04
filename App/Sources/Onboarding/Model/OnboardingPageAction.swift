import Foundation

struct OnboardingPageAction: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let action: () -> Void
    let accessibilityString: String

    static func == (lhs: OnboardingPageAction, rhs: OnboardingPageAction) -> Bool {
        lhs.id == rhs.id
    }
    
    init(title: String, action: @escaping () -> Void, accessibilityString: String = "") {
        self.title = title
        self.action = action
        self.accessibilityString = accessibilityString
    }
}
