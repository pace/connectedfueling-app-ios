import JamitFoundation
import UIKit

struct PageIndicatorViewModel: ViewModelProtocol {
    var index: Int
    var count: Int

    init(
        index: Int = Self.default.index,
        count: Int = Self.default.count
    ) {
        self.index = index
        self.count = count
    }
}

extension PageIndicatorViewModel {
    static let `default`: Self = .init(
        index: 0,
        count: 1
    )
}
