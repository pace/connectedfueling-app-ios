import SwiftUI

struct TextLabel: View {
    private let text: String
    private let textColor: Color
    private let alignment: TextAlignment

    init(_ text: String,
         textColor: Color = .textDark,
         alignment: TextAlignment = .leading) {
        self.text = text
        self.textColor = textColor
        self.alignment = alignment
    }

    var body: some View {
        Text(text)
            .foregroundStyle(textColor)
            .multilineTextAlignment(alignment)
    }
}

#Preview {
    TextLabel("This is a label")
}
