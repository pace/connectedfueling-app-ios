// swiftlint:disable:this file_name
import JamitFoundation
import UIKit

// MARK: Labels
extension LabelStyle {
    static let headline1: Self = .init(
        color: Asset.Colors.genericBlack.color,
        font: .systemFont(ofSize: 20, weight: .semibold),
        numberOfLines: 0,
        lineBreakMode: .byTruncatingTail,
        textAlignment: .center
    )

    static let headline2: Self = .init(
        color: Asset.Colors.genericBlack.color,
        font: .systemFont(ofSize: 18, weight: .semibold),
        numberOfLines: 0,
        lineBreakMode: .byTruncatingTail,
        textAlignment: .center
    )

    static let headline3: Self = .init(
        color: Asset.Colors.genericBlack.color,
        font: .systemFont(ofSize: 16, weight: .semibold),
        numberOfLines: 0,
        lineBreakMode: .byTruncatingTail,
        textAlignment: .center
    )

    static let lightBoldHeadline3: Self = .init(
        color: .white,
        font: .systemFont(ofSize: 16, weight: .bold),
        numberOfLines: 0,
        lineBreakMode: .byTruncatingTail,
        textAlignment: .left
    )

    static let headline4: Self = .init(
        color: Asset.Colors.genericBlack.color,
        font: .systemFont(ofSize: 16, weight: .medium),
        numberOfLines: 0,
        lineBreakMode: .byTruncatingTail,
        textAlignment: .center
    )

    static let headline5: Self = .init(
        color: Asset.Colors.genericBlack.color,
        font: .systemFont(ofSize: 14, weight: .semibold),
        numberOfLines: 0,
        lineBreakMode: .byTruncatingTail,
        textAlignment: .center
    )

    static let body1: Self = .init(
        color: Asset.Colors.genericBlack.color,
        font: .systemFont(ofSize: 16, weight: .medium),
        numberOfLines: 0,
        lineBreakMode: .byTruncatingTail,
        textAlignment: .center
    )

    static let body2: Self = .init(
        color: Asset.Colors.genericBlack.color,
        font: .systemFont(ofSize: 16, weight: .regular),
        numberOfLines: 0,
        lineBreakMode: .byTruncatingTail,
        textAlignment: .center
    )

    static let body3: Self = .init(
        color: Asset.Colors.genericBlack.color,
        font: .systemFont(ofSize: 12, weight: .medium),
        numberOfLines: 0,
        lineBreakMode: .byTruncatingTail,
        textAlignment: .center
    )

    static let body4: Self = .init(
        color: Asset.Colors.genericBlack.color,
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
    static let largeOutline: Self = .init(color: .black, width: 1.5, radius: .all(8))
    static let largeOutlineHighlighted: Self = .init(color: .black, width: 1.5, radius: .all(8))
    static let largeOutlineSmallRadius: Self = .init(color: .black, width: 1.5, radius: .all(4))
}

// MARK: Buttons
extension ButtonViewStyle {
    private static var dynamicHeight: CGFloat {
        return UIScreen.main.isCompactSize ? 40 : 50
    }

    static let primary: Self = .init(
        height: dynamicHeight,
        normalState: .init(
            titleStyle: LabelStyle.headline5.withColor(.white),
            borderStyle: .large,
            backgroundColor: .black
        ),
        highlightedState: .init(
            titleStyle: LabelStyle.headline5.withColor(.white),
            borderStyle: .large,
            backgroundColor: .black
        ),
        selectedState: .init(
            titleStyle: LabelStyle.headline5.withColor(.black),
            borderStyle: .largeOutline,
            backgroundColor: Asset.Colors.genericWhite.color
        ),
        disabledState: .init(
            titleStyle: LabelStyle.headline5.withColor(.white),
            borderStyle: .large,
            backgroundColor: .gray
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
            titleStyle: LabelStyle.headline5.withColor(.black),
            borderStyle: .largeOutline,
            backgroundColor: Asset.Colors.genericWhite.color
        ),
        highlightedState: .init(
            titleStyle: LabelStyle.headline5.withColor(.black),
            borderStyle: .largeOutlineHighlighted,
            backgroundColor: Asset.Colors.genericWhite.color
        ),
        selectedState: .init(
            titleStyle: LabelStyle.headline5.withColor(.black),
            borderStyle: .largeOutline,
            backgroundColor: Asset.Colors.genericWhite.color
        ),
        disabledState: .init(
            titleStyle: LabelStyle.headline5.withColor(.black),
            borderStyle: .largeOutline,
            backgroundColor: Asset.Colors.genericWhite.color
        )
    )

    static let action: Self = .init(
        height: 50,
        normalState: .init(
            titleStyle: LabelStyle.headline5.withColor(.white),
            borderStyle: .large,
            backgroundColor: .black
        ),
        highlightedState: .init(
            titleStyle: LabelStyle.headline5.withColor(Asset.Colors.genericBlack.color),
            borderStyle: .large,
            backgroundColor: .black
        ),
        selectedState: .init(
            titleStyle: LabelStyle.headline5.withColor(.black),
            borderStyle: .largeOutline,
            backgroundColor: Asset.Colors.genericWhite.color
        ),
        disabledState: .init(
            titleStyle: LabelStyle.headline5.withColor(.white),
            borderStyle: .large,
            backgroundColor: .gray
        )
    )

    static let secondaryAction: Self = .init(
        height: 50,
        normalState: .init(
            titleStyle: LabelStyle.headline5.withColor(.black),
            borderStyle: .largeOutline,
            backgroundColor: Asset.Colors.genericWhite.color
        ),
        highlightedState: .init(
            titleStyle: LabelStyle.headline5.withColor(.black),
            borderStyle: .largeOutlineHighlighted,
            backgroundColor: .clear
        ),
        selectedState: .init(
            titleStyle: LabelStyle.headline5.withColor(.black),
            borderStyle: .largeOutline,
            backgroundColor: Asset.Colors.genericWhite.color,
            shadowColor: .gray
        ),
        disabledState: .init(
            titleStyle: LabelStyle.headline5.withColor(.black),
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
        backgroundColor: Asset.Colors.genericWhite.color,
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
        backgroundColor: Asset.Colors.genericWhite.color,
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
            .withColor(Asset.Colors.genericRed.color)
            .withTextAlignment(.left)
    )
}

// MARK: PageIndicatorView
extension PageIndicatorViewStyle {
    static let `default`: Self = .init(
        backgroundColor: .gray,
        foregroundColor: .gray,
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
        distanceBadgeLabelStyle: .body1.withColor(.black),
        shadowColor: Asset.Colors.shadow.color,
        shadowOffset: .init(x: 0, y: 2),
        shadowRadius: 10
    )
}

// MARK: Menu
extension MenuViewStyle {
    static let `default`: Self = .init(
        headerBackground: .black,
        headerTitleStyle: .lightBoldHeadline3
    )
}

extension MenuItemViewStyle {
    static let `default`: Self = .init(
        titleStyle: .body1
    )
}
