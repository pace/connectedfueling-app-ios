// swiftlint:disable:this file_name
import JamitFoundation
import UIKit

// MARK: Labels
extension LabelStyle {
    static let headline1: Self = .init(
        color: Asset.Colors.textDark.color,
        font: .systemFont(ofSize: 20, weight: .semibold),
        numberOfLines: 0,
        lineBreakMode: .byTruncatingTail,
        textAlignment: .center
    )

    static let headline2: Self = .init(
        color: Asset.Colors.textDark.color,
        font: .systemFont(ofSize: 18, weight: .semibold),
        numberOfLines: 0,
        lineBreakMode: .byTruncatingTail,
        textAlignment: .center
    )

    static let headline3: Self = .init(
        color: Asset.Colors.textDark.color,
        font: .systemFont(ofSize: 16, weight: .semibold),
        numberOfLines: 0,
        lineBreakMode: .byTruncatingTail,
        textAlignment: .center
    )

    static let lightBoldHeadline3: Self = .init(
        color: Asset.Colors.textLight.color,
        font: .systemFont(ofSize: 16, weight: .bold),
        numberOfLines: 0,
        lineBreakMode: .byTruncatingTail,
        textAlignment: .left
    )

    static let headline4: Self = .init(
        color: Asset.Colors.textDark.color,
        font: .systemFont(ofSize: 16, weight: .medium),
        numberOfLines: 0,
        lineBreakMode: .byTruncatingTail,
        textAlignment: .center
    )

    static let headline5: Self = .init(
        color: Asset.Colors.textDark.color,
        font: .systemFont(ofSize: 14, weight: .semibold),
        numberOfLines: 0,
        lineBreakMode: .byTruncatingTail,
        textAlignment: .center
    )

    static let body1: Self = .init(
        color: Asset.Colors.textDark.color,
        font: .systemFont(ofSize: 16, weight: .medium),
        numberOfLines: 0,
        lineBreakMode: .byTruncatingTail,
        textAlignment: .center
    )

    static let body2: Self = .init(
        color: Asset.Colors.textDark.color,
        font: .systemFont(ofSize: 16, weight: .regular),
        numberOfLines: 0,
        lineBreakMode: .byTruncatingTail,
        textAlignment: .center
    )

    static let body3: Self = .init(
        color: Asset.Colors.textDark.color,
        font: .systemFont(ofSize: 12, weight: .medium),
        numberOfLines: 0,
        lineBreakMode: .byTruncatingTail,
        textAlignment: .center
    )

    static let body4: Self = .init(
        color: Asset.Colors.textDark.color,
        font: .systemFont(ofSize: 12, weight: .regular),
        numberOfLines: 0,
        lineBreakMode: .byTruncatingTail,
        textAlignment: .center
    )

    func withColor(_ color: UIColor) -> Self {
        return .init(
            color: color,
            font: font,
            numberOfLines: numberOfLines,
            lineBreakMode: lineBreakMode,
            textAlignment: textAlignment
        )
    }

    func withAlphaComponent(_ alpha: CGFloat) -> Self {
        return .init(
            color: color.withAlphaComponent(alpha),
            font: font,
            numberOfLines: numberOfLines,
            lineBreakMode: lineBreakMode,
            textAlignment: textAlignment
        )
    }

    func withTextAlignment(_ textAlignment: NSTextAlignment) -> Self {
        return .init(
            color: color,
            font: font,
            numberOfLines: numberOfLines,
            lineBreakMode: lineBreakMode,
            textAlignment: textAlignment
        )
    }

    func withNumberOfLines(_ numberOfLines: Int) -> Self {
        return .init(
            color: color,
            font: font,
            numberOfLines: numberOfLines,
            lineBreakMode: lineBreakMode,
            textAlignment: textAlignment
        )
    }
}

// MARK: Borders
extension BorderStyle {
    static let none: Self = .init(color: .clear, width: 0, radius: 0)
    static let circular: Self = .init(color: .clear, width: 0, radius: .circular)
    static let small: Self = .init(color: .clear, width: 0, radius: .all(4))
    static let large: Self = .init(color: .clear, width: 0, radius: .all(8))
    static let largeOutline: Self = .init(color: Asset.Colors.primaryTint.color, width: 1.5, radius: .all(8))
    static let largeOutlineHighlighted: Self = .init(color: Asset.Colors.primaryTint.color.withAlphaComponent(0.75), width: 1.5, radius: .all(8))
    static let largeOutlineSmallRadius: Self = .init(color: Asset.Colors.primaryTint.color, width: 1.5, radius: .all(4))
}

// MARK: Buttons
extension ButtonViewStyle {
    private static var dynamicHeight: CGFloat {
        return UIScreen.main.isCompactSize ? 40 : 50
    }

    static let primary: Self = .init(
        height: dynamicHeight,
        normalState: .init(
            titleStyle: LabelStyle.headline5.withColor(Asset.Colors.textLight.color),
            borderStyle: .large,
            backgroundColor: Asset.Colors.primaryTint.color
        ),
        highlightedState: .init(
            titleStyle: LabelStyle.headline5.withColor(Asset.Colors.textLight.color),
            borderStyle: .large,
            backgroundColor: Asset.Colors.primaryTint.color.withAlphaComponent(0.75)
        ),
        selectedState: .init(
            titleStyle: LabelStyle.headline5.withColor(Asset.Colors.primaryTint.color),
            borderStyle: .largeOutline,
            backgroundColor: Asset.Colors.background.color
        ),
        disabledState: .init(
            titleStyle: LabelStyle.headline5.withColor(Asset.Colors.textLight.color),
            borderStyle: .large,
            backgroundColor: Asset.Colors.disabled.color
        )
    )

    static let secondary: Self = .init(
        height: dynamicHeight,
        normalState: .init(
            titleStyle: LabelStyle.headline4,
            borderStyle: .large,
            backgroundColor: .clear
        ),
        highlightedState: .init(
            titleStyle: LabelStyle.headline4.withAlphaComponent(0.8),
            borderStyle: .large,
            backgroundColor: .clear
        ),
        selectedState: .init(
            titleStyle: LabelStyle.headline4,
            borderStyle: .large,
            backgroundColor: .clear
        ),
        disabledState: .init(
            titleStyle: LabelStyle.headline4.withAlphaComponent(0.6),
            borderStyle: .large,
            backgroundColor: .clear
        )
    )

    static let radio: Self = .init(
        height: dynamicHeight,
        normalState: .init(
            titleStyle: LabelStyle.headline5.withColor(Asset.Colors.primaryTint.color),
            borderStyle: .largeOutline,
            backgroundColor: Asset.Colors.background.color
        ),
        highlightedState: .init(
            titleStyle: LabelStyle.headline5.withColor(Asset.Colors.primaryTint.color.withAlphaComponent(0.75)),
            borderStyle: .largeOutlineHighlighted,
            backgroundColor: Asset.Colors.background.color
        ),
        selectedState: .init(
            titleStyle: LabelStyle.headline5.withColor(Asset.Colors.primaryTint.color),
            borderStyle: .largeOutline,
            backgroundColor: Asset.Colors.background.color
        ),
        disabledState: .init(
            titleStyle: LabelStyle.headline5.withColor(Asset.Colors.primaryTint.color),
            borderStyle: .largeOutline,
            backgroundColor: Asset.Colors.background.color
        )
    )

    static let action: Self = .init(
        height: 50,
        normalState: .init(
            titleStyle: LabelStyle.headline5.withColor(Asset.Colors.textLight.color),
            borderStyle: .large,
            backgroundColor: Asset.Colors.primaryTint.color
        ),
        highlightedState: .init(
            titleStyle: LabelStyle.headline5.withColor(Asset.Colors.textDark.color),
            borderStyle: .large,
            backgroundColor: Asset.Colors.primaryTint.color.withAlphaComponent(0.75)
        ),
        selectedState: .init(
            titleStyle: LabelStyle.headline5.withColor(Asset.Colors.primaryTint.color),
            borderStyle: .largeOutline,
            backgroundColor: Asset.Colors.background.color
        ),
        disabledState: .init(
            titleStyle: LabelStyle.headline5.withColor(Asset.Colors.textLight.color),
            borderStyle: .large,
            backgroundColor: Asset.Colors.disabled.color
        )
    )

    static let secondaryAction: Self = .init(
        height: 50,
        normalState: .init(
            titleStyle: LabelStyle.headline5.withColor(Asset.Colors.primaryTint.color),
            borderStyle: .largeOutline,
            backgroundColor: Asset.Colors.background.color
        ),
        highlightedState: .init(
            titleStyle: LabelStyle.headline5.withColor(Asset.Colors.primaryTint.color.withAlphaComponent(0.75)),
            borderStyle: .largeOutlineHighlighted,
            backgroundColor: .clear
        ),
        selectedState: .init(
            titleStyle: LabelStyle.headline5.withColor(Asset.Colors.primaryTint.color),
            borderStyle: .largeOutline,
            backgroundColor: Asset.Colors.background.color,
            shadowColor: Asset.Colors.buttonShadowLight.color
        ),
        disabledState: .init(
            titleStyle: LabelStyle.headline5.withColor(Asset.Colors.primaryTint.color),
            borderStyle: .largeOutline,
            backgroundColor: .clear
        )
    )
}

// MARK: Onboarding
extension OnboardingViewStyle {
    static var `default`: Self {
        return UIScreen.main.isCompactSize ? .compact : .regular
    }

    static let regular: Self = .init(
        titleStyle: .headline1,
        descriptionStyle: .body2,
        primaryAction: .primary,
        secondaryAction: .secondary,
        radio: .radio,
        backgroundColor: Asset.Colors.background.color,
        iconSpacingTop: 100,
        iconSpacingBottom: 40,
        descriptionInsets: .init(top: 14, left: 60, bottom: 40, right: 60)
    )

    static let compact: Self = .init(
        titleStyle: .headline1,
        descriptionStyle: .body2,
        primaryAction: .primary,
        secondaryAction: .secondary,
        radio: .radio,
        backgroundColor: Asset.Colors.background.color,
        iconSpacingTop: 60,
        iconSpacingBottom: 40,
        descriptionInsets: .init(top: 14, left: 30, bottom: 20, right: 30)
    )
}

// MARK: InputView
extension InputViewStyle {
    static let `default`: Self = .init(
        titleStyle: .headline1,
        descriptionStyle: .body2,
        errorStyle: LabelStyle.body4
            .withColor(Asset.Colors.danger.color)
            .withTextAlignment(.left)
    )
}

// MARK: PageIndicatorView
extension PageIndicatorViewStyle {
    static let `default`: Self = .init(
        backgroundColor: Asset.Colors.pageIndicatorBackground.color,
        foregroundColor: Asset.Colors.pageIndicatorForeground.color,
        spacing: 10
    )
}

// MARK: Dashboard
extension DashboardHeaderViewStyle {
    static let `default`: Self = .init(
        titleStyle: LabelStyle.headline1.withTextAlignment(.left)
    )
}

extension DashboardItemViewStyle {
    static let `default`: Self = .init(
        backgroundColor: .white,
        titleStyle: LabelStyle.headline2
            .withTextAlignment(.left)
            .withNumberOfLines(2),
        descriptionStyle: LabelStyle.body1
            .withTextAlignment(.left)
            .withNumberOfLines(0),
        priceStyle: LabelStyle.headline1
            .withTextAlignment(.center),
        fuelTypeStyle: LabelStyle.body3.withTextAlignment(.center),
        borderStyle: .large,
        actionStyle: .action,
        distanceBadgeLabelStyle: .body1.withColor(Asset.Colors.primaryTint.color),
        shadowColor: Asset.Colors.shadow.color,
        shadowOffset: .init(x: 0, y: 2),
        shadowRadius: 10
    )
}

// MARK: Menu
extension MenuViewStyle {
    static let `default`: Self = .init(
        headerBackground: Asset.Colors.primaryTint.color,
        headerTitleStyle: .lightBoldHeadline3
    )
}

extension MenuItemViewStyle {
    static let `default`: Self = .init(
        titleStyle: .body1
    )
}
