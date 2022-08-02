import JamitFoundation
import UIKit

struct DashboardItemViewStyle {
    let backgroundColor: UIColor
    let titleStyle: LabelStyle
    let descriptionStyle: LabelStyle
    let priceStyle: LabelStyle
    let fuelTypeStyle: LabelStyle
    let borderStyle: BorderStyle
    let actionStyle: ButtonViewStyle
    let distanceBadgeLabelStyle: LabelStyle
    let shadowColor: UIColor
    let shadowOffset: CGPoint
    let shadowRadius: CGFloat

    init(
        backgroundColor: UIColor = Self.default.backgroundColor,
        titleStyle: LabelStyle = Self.default.titleStyle,
        descriptionStyle: LabelStyle = Self.default.descriptionStyle,
        priceStyle: LabelStyle = Self.default.priceStyle,
        fuelTypeStyle: LabelStyle = Self.default.fuelTypeStyle,
        borderStyle: BorderStyle = Self.default.borderStyle,
        actionStyle: ButtonViewStyle = Self.default.actionStyle,
        distanceBadgeLabelStyle: LabelStyle = Self.default.distanceBadgeLabelStyle,
        shadowColor: UIColor = Self.default.shadowColor,
        shadowOffset: CGPoint = Self.default.shadowOffset,
        shadowRadius: CGFloat = Self.default.shadowRadius
    ) {
        self.backgroundColor = backgroundColor
        self.titleStyle = titleStyle
        self.descriptionStyle = descriptionStyle
        self.priceStyle = priceStyle
        self.fuelTypeStyle = fuelTypeStyle
        self.borderStyle = borderStyle
        self.actionStyle = actionStyle
        self.distanceBadgeLabelStyle = distanceBadgeLabelStyle
        self.shadowColor = shadowColor
        self.shadowOffset = shadowOffset
        self.shadowRadius = shadowRadius
    }
}
