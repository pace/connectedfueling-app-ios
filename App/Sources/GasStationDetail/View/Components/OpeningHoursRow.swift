import SwiftUI

struct OpeningHoursRow: View {
    var leftText: String
    let rightText: String

    var body: some View {
        HStack {
            TextLabel(leftText)
            Spacer()
            TextLabel(rightText)
        }
    }
}

#Preview {
    OpeningHoursRow(leftText: "Monday - Sunday", rightText: "06:00 - 23:00 Uhr")
}
