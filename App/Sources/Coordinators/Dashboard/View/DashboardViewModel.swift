import JamitFoundation
import UIKit

struct DashboardViewModel: ViewModelProtocol {
    enum Row {
        case header(DashboardHeaderViewModel)
        case item(DashboardItemViewModel)
    }

    var rows: [Row]
    var isLoading: Bool

    init(
        rows: [Row] = Self.default.rows,
        isLoading: Bool = Self.default.isLoading
    ) {
        self.rows = rows
        self.isLoading = isLoading
    }
}

extension DashboardViewModel {
    static let `default`: Self = .init(
        rows: [],
        isLoading: false
    )
}
