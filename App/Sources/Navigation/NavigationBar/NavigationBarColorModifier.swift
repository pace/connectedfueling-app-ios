// Copyright © 2023 PACE Telematics GmbH. All rights reserved.

import SwiftUI

struct NavigationBarColorModifier<Background>: ViewModifier where Background: View {
    let background: () -> Background
    public init(@ViewBuilder background: @escaping () -> Background) {
        self.background = background
    }

    func body(content: Content) -> some View {
        ZStack {
            content
            VStack {
                background()
                    .edgesIgnoringSafeArea([.top, .leading, .trailing])
                    .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 0, alignment: .center)
                Spacer()
            }
        }
    }
}
