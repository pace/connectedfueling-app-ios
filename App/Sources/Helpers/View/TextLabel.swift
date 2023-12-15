import SwiftUI

struct TextLabel: View {
    private let text: String?
    private let attributedText: AttributedString?
    private let textColor: Color
    private let alignment: TextAlignment

    init(_ text: String,
         textColor: Color = .genericBlack,
         alignment: TextAlignment = .center) {
        self.text = text
        self.attributedText = nil
        self.textColor = textColor
        self.alignment = alignment
    }

    init(_ attributedText: AttributedString,
         textColor: Color = .genericBlack,
         alignment: TextAlignment = .center) {
        self.text = nil
        self.attributedText = attributedText
        self.textColor = textColor
        self.alignment = alignment
    }

    var body: some View {
        if let text {
            // Use explicit String initializers to enable markdown
            Text(.init(text))
                .foregroundStyle(textColor)
                .tint(.primaryTint)
                .multilineTextAlignment(alignment)
        } else if let attributedText {
            Text(attributedText)
                .foregroundStyle(textColor)
                .multilineTextAlignment(alignment)
        }
    }
}

#Preview {
    TextLabel("This is a label")
}