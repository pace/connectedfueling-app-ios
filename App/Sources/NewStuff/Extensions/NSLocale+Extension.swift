// Copyright © 2023 PACE Telematics GmbH. All rights reserved.

import Foundation

extension NSLocale {
    static func symbol(for currencyCode: String) -> String {
        let locale = NSLocale(localeIdentifier: currencyCode)
        if locale.displayName(forKey: .currencySymbol, value: currencyCode) == currencyCode {
            let newlocale = NSLocale(localeIdentifier: currencyCode.dropLast() + "_en")
            return newlocale.displayName(forKey: .currencySymbol, value: currencyCode) ?? ""
        }
        return locale.displayName(forKey: .currencySymbol, value: currencyCode) ?? ""
    }
}
