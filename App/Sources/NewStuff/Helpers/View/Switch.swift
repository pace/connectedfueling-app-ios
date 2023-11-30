import SwiftUI

struct Switch: View {
    @State private var isOn: Bool

    private let onTap: (Bool) async -> Bool

    init(isOn: Bool, onTap: @escaping (Bool) async -> Bool) {
        self.isOn = isOn
        self.onTap = onTap
    }

    var body: some View {
        Toggle("", isOn: .init(get: {
            isOn
        }, set: { newValue in
            Task { @MainActor in
                self.isOn = await self.onTap(newValue)
            }
        }))
        .tint(.primaryTint)
    }
}

#Preview {
    VStack {
        Switch(isOn: true, onTap: { _ in true })
        Switch(isOn: false, onTap: { _ in false })
    }
}
