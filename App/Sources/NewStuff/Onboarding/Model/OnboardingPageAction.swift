import Foundation

struct OnboardingPageAction: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let action: () -> Void

    static func == (lhs: OnboardingPageAction, rhs: OnboardingPageAction) -> Bool {
        lhs.id == rhs.id
    }
}
