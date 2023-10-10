// Copyright © 2023 PACE Telematics GmbH. All rights reserved.

import SwiftUI

struct PageView<Content>: View where Content: View {
    @Binding private var selectedIndex: Int

    private let indexDisplayMode: PageTabViewStyle.IndexDisplayMode
    private let indexBackgroundDisplayMode: PageIndexViewStyle.BackgroundDisplayMode
    private let content: () -> Content

    init(selectedIndex: Binding<Int>,
         indexDisplayMode: PageTabViewStyle.IndexDisplayMode = .automatic,
         indexBackgroundDisplayMode: PageIndexViewStyle.BackgroundDisplayMode = .automatic,
         @ViewBuilder content: @escaping () -> Content) {
        self._selectedIndex = selectedIndex
        self.indexDisplayMode = indexDisplayMode
        self.indexBackgroundDisplayMode = indexBackgroundDisplayMode
        self.content = content
    }

    var body: some View {
        TabView(selection: $selectedIndex) {
            content()
        }
        .tabViewStyle(.page(indexDisplayMode: indexDisplayMode))
        .indexViewStyle(.page(backgroundDisplayMode: indexBackgroundDisplayMode))
    }
}

#Preview {
    PageView(selectedIndex: .constant(2), indexDisplayMode: .always, indexBackgroundDisplayMode: .always, content: {
        Text("Test 1")
        Text("Test 2")
        Text("Test 3")
    })
}
