import JamitFoundation
import UIKit

struct DashboardHeaderViewStyle {
    let titleStyle: LabelStyle

    init(
        titleStyle: LabelStyle = Self.default.titleStyle
    ) {
        self.titleStyle = titleStyle
    }
}
