import SwiftUI

struct Switch: View {
    private let isOn: Bool
    private let onTap: (Bool) -> Void

    init(isOn: Bool, onTap: @escaping (Bool) -> Void) {
        self.isOn = isOn
        self.onTap = onTap
    }

    var body: some View {
        Toggle("", isOn: .init(get: {
            isOn
        }, set: { newValue in
            onTap(newValue)
        }))
        .labelsHidden()
        .tint(.primaryTint)
    }
}

#Preview {
    VStack {
        Switch(isOn: true, onTap: { _ in })
        Switch(isOn: false, onTap: { _ in })
    }
}
