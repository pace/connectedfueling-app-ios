import SwiftUI

class WalletListItemViewModel: ObservableObject, Identifiable {
    @Published var isPresentingApp: Bool = false

    let icon: ImageResource
    let title: String
    let navigationType: NavigationType

    init(icon: ImageResource, title: String, navigationType: NavigationType) {
        self.icon = icon
        self.title = title
        self.navigationType = navigationType
    }

    func presentApp() {
        isPresentingApp = true
    }
}

extension WalletListItemViewModel {
    enum NavigationType {
        case appPresentation(urlString: String)
        case detail(destination: AnyView)
    }
}
