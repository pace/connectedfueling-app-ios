import SwiftUI

class PriceNumberFormatter: NumberFormatter {

    private var _formatString: String = "d.dds" {
        didSet {
            configureFormatter(with: _formatString)
        }
    }

    var formatString: String {
        get {
            return _formatString
        }

        set {
            _formatString = newValue.isEmpty ? "d.dds" : newValue
        }
    }

    private var usesSuperscript: Bool = true

    override init() {
        super.init()
        self.locale = .current
        self.numberStyle = .decimal
        self.formatString = "d.dds"
        configureFormatter(with: _formatString)
    }

    init(with format: String = "d.dds", locale: Locale = .current) {
        super.init()
        self.locale = .current
        self.numberStyle = .decimal
        self.formatString = format
        configureFormatter(with: _formatString)
    }

    required init?(coder: NSCoder) {
        fatalError("Not supported.")
    }

    func localizedPrice(from number: NSNumber, currencySymbol: String) -> AttributedString? {
        guard let formattedString = super.string(from: number) else { return nil }

        let localizedPrice = L10n.currencyFormat(formattedString, currencySymbol)

        guard usesSuperscript else { return .init(localizedPrice) }

        let superscriptString = addSuperscriptToLastDigit(of: localizedPrice)
        return superscriptString
    }

    private func configureFormatter(with format: String) {
        let integerDigitsCount = integerDigitsCount(in: format)
        let fractionDigitsCount = fractionDigitsCount(in: format)

        minimumIntegerDigits = integerDigitsCount
        minimumFractionDigits = fractionDigitsCount
        maximumFractionDigits = fractionDigitsCount
    }

    private func integerDigitsCount(in format: String) -> Int {
        guard let separator = format.range(of: ".") else { fatalError() }
        let integerDigitsRange = format.startIndex ..< separator.lowerBound
        return format[integerDigitsRange].count
    }

    private func fractionDigitsCount(in format: String) -> Int {
        guard let separator = format.range(of: ".") else { fatalError() }
        let fractionDigitsRange = separator.upperBound ..< format.endIndex
        let fractionDigitsString = format[fractionDigitsRange]

        usesSuperscript = fractionDigitsString.contains("s")

        return fractionDigitsString.count
    }

    private func addSuperscriptToLastDigit(of string: String) -> AttributedString {
        let textColor: Color = .genericBlack
        let font: Font = .system(size: 24, weight: .heavy)
        let fontSuperscript: Font = .system(size: 14, weight: .heavy)

        guard let superscriptIndex = string.lastIndex(where: { $0.isNumber }) else {
            return .init(string)
        }

        var attributedString = AttributedString(string)
        attributedString.font = font
        attributedString.foregroundColor = textColor

        guard let lowerBoundIndex = AttributedString.Index(superscriptIndex, within: attributedString),
              let upperBoundIndex = AttributedString.Index(string.index(superscriptIndex, offsetBy: 1), within: attributedString) else {
            return attributedString
        }

        var superscriptContainer = AttributeContainer()
        superscriptContainer.baselineOffset = 7
        superscriptContainer.font = fontSuperscript
        superscriptContainer.foregroundColor = textColor

        let superscriptRange = Range(uncheckedBounds: (lower: lowerBoundIndex, upper: upperBoundIndex))
        attributedString[superscriptRange].setAttributes(superscriptContainer)

        return attributedString
    }
}
