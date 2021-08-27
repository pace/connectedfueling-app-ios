import JamitFoundation
import UIKit

struct DashboardItemViewStyle {
    let backgroundColor: UIColor
    let titleStyle: LabelStyle
    let priceStyle: LabelStyle
    let borderStyle: BorderStyle
    let actionStyle: ButtonViewStyle
    let distanceBadgeBackgroundColor: UIColor
    let distanceBadgeBorderStyle: BorderStyle
    let distanceBadgeLabelStyle: LabelStyle
    let shadowColor: UIColor
    let shadowOffset: CGPoint
    let shadowRadius: CGFloat

    init(
        backgroundColor: UIColor = Self.default.backgroundColor,
        titleStyle: LabelStyle = Self.default.titleStyle,
        priceStyle: LabelStyle = Self.default.priceStyle,
        borderStyle: BorderStyle = Self.default.borderStyle,
        actionStyle: ButtonViewStyle = Self.default.actionStyle,
        distanceBadgeBackgroundColor: UIColor = Self.default.distanceBadgeBackgroundColor,
        distanceBadgeBorderStyle: BorderStyle = Self.default.distanceBadgeBorderStyle,
        distanceBadgeLabelStyle: LabelStyle = Self.default.distanceBadgeLabelStyle,
        shadowColor: UIColor = Self.default.shadowColor,
        shadowOffset: CGPoint = Self.default.shadowOffset,
        shadowRadius: CGFloat = Self.default.shadowRadius
    ) {
        self.backgroundColor = backgroundColor
        self.titleStyle = titleStyle
        self.priceStyle = priceStyle
        self.borderStyle = borderStyle
        self.actionStyle = actionStyle
        self.distanceBadgeBackgroundColor = distanceBadgeBackgroundColor
        self.distanceBadgeBorderStyle = distanceBadgeBorderStyle
        self.distanceBadgeLabelStyle = distanceBadgeLabelStyle
        self.shadowColor = shadowColor
        self.shadowOffset = shadowOffset
        self.shadowRadius = shadowRadius
    }
}
