import SwiftUI

extension Color {
    static let background = Color("Background")
    static let complementary = Color("Complementary")
    static let error = Color("Error")
    static let primaryText = Color("PrimaryText")
    static let primaryTint = ConfigurationManager.configuration.primaryBrandingColor
    static let secondaryText = Color("SecondaryText")
    static let secondaryTint = ConfigurationManager.configuration.secondaryBrandingColor
    static let shadow = Color("Shadow")
    static let success = Color("Success")
}

extension Color {
    init(hex: String) {
        let r, g, b: CGFloat

        guard hex.hasPrefix("#") else {
            fatalError("Could not convert hexString to Color. Invalid hex string.")
        }

        let start = hex.index(hex.startIndex, offsetBy: 1)
        let hexColor = String(hex[start...])

        guard hexColor.count == 6 else {
            fatalError("Could not convert hexString to Color. Invalid hex count.")
        }

        let scanner = Scanner(string: hexColor)
        var hexNumber: UInt64 = 0

        guard scanner.scanHexInt64(&hexNumber) else {
            fatalError("Could not convert hexString to Color. No hex representation found.")
        }

        r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
        g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
        b = CGFloat((hexNumber & 0x0000ff) >> 0) / 255

        self = .init(red: r, green: g, blue: b)
    }
}
