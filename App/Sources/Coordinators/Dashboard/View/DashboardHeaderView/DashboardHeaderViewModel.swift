import JamitFoundation
import UIKit

struct DashboardHeaderViewModel: ViewModelProtocol {
    let title: String

    init(
        title: String = Self.default.title
    ) {
        self.title = title
    }
}

extension DashboardHeaderViewModel {
    static let `default`: Self = .init(
        title: ""
    )
}
