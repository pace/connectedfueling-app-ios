import SwiftUI

struct DisclosureIndicator: View {
    var body: some View {
        Image.disclosureIndicator
            .foregroundStyle(Color.genericGrey)
    }
}

#Preview {
    DisclosureIndicator()
}
