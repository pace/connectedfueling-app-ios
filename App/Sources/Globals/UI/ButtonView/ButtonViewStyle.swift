import JamitFoundation
import UIKit

struct ButtonViewStyle {
    let height: CGFloat
    let normalState: State
    let highlightedState: State
    let selectedState: State
    let disabledState: State

    init(
        height: CGFloat = Self.primary.height,
        normalState: State = Self.primary.normalState,
        highlightedState: State = Self.primary.highlightedState,
        selectedState: State = Self.primary.selectedState,
        disabledState: State = Self.primary.disabledState
    ) {
        self.height = height
        self.normalState = normalState
        self.highlightedState = highlightedState
        self.selectedState = selectedState
        self.disabledState = disabledState
    }
}

extension ButtonViewStyle {
    struct State {
        let titleStyle: LabelStyle
        let borderStyle: BorderStyle
        let backgroundColor: UIColor
        let shadowColor: UIColor
        let shadowOffset: CGPoint
        let shadowRadius: CGFloat

        init(
            titleStyle: LabelStyle = .default,
            borderStyle: BorderStyle = .default,
            backgroundColor: UIColor = .clear,
            shadowColor: UIColor = .clear,
            shadowOffset: CGPoint = .zero,
            shadowRadius: CGFloat = .zero
        ) {
            self.titleStyle = titleStyle
            self.borderStyle = borderStyle
            self.backgroundColor = backgroundColor
            self.shadowColor = shadowColor
            self.shadowOffset = shadowOffset
            self.shadowRadius = shadowRadius
        }
    }
}
