// Copyright © 2023 PACE Telematics GmbH. All rights reserved.

import SwiftUI

struct ActionButton: View {
    enum Style {
        case primary
        case secondary
    }

    private let title: String
    private let style: Style
    private let action: () -> Void

    init(title: String, style: Style = .primary, action: @escaping () -> Void) {
        self.title = title
        self.style = style
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Text(title)
                .frame(maxWidth: .infinity, minHeight: 50)
                .foregroundStyle(style == .primary ? Color.textLight : Color.textDark)
                .background(style == .primary ? Color.primaryTint : Color.clear)
                .font(style == .primary ? .system(size: 14, weight: .semibold) : .system(size: 16, weight: .medium))
        }
        .cornerRadius(8)
    }
}

#Preview {
    VStack {
        ActionButton(title: "Primary Button", action: {})
        ActionButton(title: "Secondary Button", style: .secondary, action: {})
    }
}
