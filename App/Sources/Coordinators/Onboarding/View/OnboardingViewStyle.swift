import JamitFoundation
import UIKit

struct OnboardingViewStyle {
    let titleStyle: LabelStyle
    let descriptionStyle: LabelStyle
    let primaryAction: ButtonViewStyle
    let secondaryAction: ButtonViewStyle
    let backgroundColor: UIColor
    let iconSpacingTop: CGFloat
    let iconSpacingBottom: CGFloat
    let iconWidth: CGFloat
    let descriptionInsets: UIEdgeInsets

    init(
        titleStyle: LabelStyle = Self.default.titleStyle,
        descriptionStyle: LabelStyle = Self.default.descriptionStyle,
        primaryAction: ButtonViewStyle = Self.default.primaryAction,
        secondaryAction: ButtonViewStyle = Self.default.secondaryAction,
        backgroundColor: UIColor = Self.default.backgroundColor,
        iconSpacingTop: CGFloat = Self.default.iconSpacingTop,
        iconSpacingBottom: CGFloat = Self.default.iconSpacingBottom,
        iconWidth: CGFloat = Self.default.iconWidth,
        descriptionInsets: UIEdgeInsets = Self.default.descriptionInsets
    ) {
        self.titleStyle = titleStyle
        self.descriptionStyle = descriptionStyle
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
        self.backgroundColor = backgroundColor
        self.iconSpacingTop = iconSpacingTop
        self.iconSpacingBottom = iconSpacingBottom
        self.iconWidth = iconWidth
        self.descriptionInsets = descriptionInsets
    }
}
