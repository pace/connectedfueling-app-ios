import SwiftUI
import UIKit

extension Color {
    static let primaryTint = ConfigurationManager.configuration.primaryBrandingColor
    static let primaryTintLight = ConfigurationManager.configuration.primaryBrandingColor.opacity(0.2)
    static let secondaryTint = ConfigurationManager.configuration.secondaryBrandingColor
    static let highlight = ConfigurationManager.configuration.highlightColor
    static let textButtons = ConfigurationManager.configuration.textButtonsColor

    static let genericBlack = Color("generic_black")
    static let genericGreen = Color("generic_green")
    static let genericGrey = Color("generic_grey")
    static let genericOrange = Color("generic_orange")
    static let genericRed = Color("generic_red")
    static let genericWhite = Color("generic_white")
    static let genericYellow = Color("generic_yellow")
    static let lightGrey = Color("light_grey")
    static let shadow = Color("shadow")
}

extension Color {
    var contrastColor: Color {
        let hexString = self.hexString
        let rgbValues = Color.rgbValues(hex: hexString)
        let intensity = (rgbValues.r * 0.299) + (rgbValues.g * 0.587) + (rgbValues.b * 0.114)
        return intensity > 186 ? .genericBlack : .genericWhite
    }

    var hexString: String {
        let uiColor = UIColor(self)

        let components = uiColor.cgColor.components
        let r: CGFloat = components?[0] ?? 0.0
        let g: CGFloat = components?[1] ?? 0.0
        let b: CGFloat = components?[2] ?? 0.0

        let hexString = String(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
        return hexString
    }

    init(hex: String) {
        let rgbValues = Color.rgbValues(hex: hex)
        self = .init(red: rgbValues.r, green: rgbValues.g, blue: rgbValues.b)
    }

    static func rgbValues(hex: String) -> (r: CGFloat, g: CGFloat, b: CGFloat) {
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

        return (r, g, b)
    }
}
