import SwiftUI

struct AppError {
    let title: String
    let description: String?
    let icon: Icon
    let retryAction: RetryAction?

    init(title: String,
         description: String? = nil,
         icon: Icon = .imageResource(.errorIcon),
         retryAction: RetryAction? = nil) {
        self.title = title
        self.description = description
        self.icon = icon
        self.retryAction = retryAction
    }
}

extension AppError {
    enum Icon {
        case imageResource(ImageResource)
        case image(Image)
    }

    struct RetryAction {
        let title: String
        let action: () -> Void
    }
}
