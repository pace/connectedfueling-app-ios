import SwiftUI

struct ListItem: Identifiable {
    let id: UUID = .init()
    let icon: ImageResource
    let title: String
    let action: Action

    init(icon: ImageResource, title: String, action: Action) {
        self.icon = icon
        self.title = title
        self.action = action
    }
}

extension ListItem {
    enum Action {
        case presentedContent(AnyView)
        case detail(destination: AnyView)
    }
}
