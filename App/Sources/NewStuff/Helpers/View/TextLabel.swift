// Copyright © 2023 PACE Telematics GmbH. All rights reserved.

import SwiftUI

struct TextLabel: View {
    private let text: String

    init(_ text: String) {
        self.text = text
    }

    var body: some View {
        Text(text)
            .foregroundStyle(Color.textDark)
            .multilineTextAlignment(.center)
    }
}

#Preview {
    TextLabel("This is a label")
}
