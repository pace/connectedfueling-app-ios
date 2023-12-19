// Copyright © 2023 PACE Telematics GmbH. All rights reserved.

import SwiftUI

struct NavigationBarTransparentStyle: ViewModifier {
    static var transparentAppearanceDict: [Color: UINavigationBarAppearance] = [:]
    static let defaultTransparentAppearance: UINavigationBarAppearance = {
        makeAppearance()
    }()

    init() {
        let apply: (UINavigationBarAppearance) -> Void = {
            guard UINavigationBar.appearance() != $0 else { return }
            UINavigationBar.appearance().standardAppearance = $0
            UINavigationBar.appearance().scrollEdgeAppearance = $0
            UINavigationBar.appearance().compactAppearance = $0
        }

        apply(Self.defaultTransparentAppearance)
    }

    static func makeAppearance() -> UINavigationBarAppearance {
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithTransparentBackground()
        coloredAppearance.backgroundColor = .clear
        return coloredAppearance
    }

    func body(content: Content) -> some View { content }
}
