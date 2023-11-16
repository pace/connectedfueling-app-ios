import SwiftUI

struct DisclosureIndicator: View {
    var body: some View {
        Image.disclosureIndicator
            .foregroundStyle(Color.secondaryText)
    }
}

#Preview {
    DisclosureIndicator()
}
