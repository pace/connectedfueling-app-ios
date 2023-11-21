import SwiftUI

extension ConfigurationManager {
    struct Configuration: Decodable {
        let clientId: String
        let primaryBrandingColorHex: String
        let secondaryBrandingColorHex: String

        private(set) var isNativeFuelCardManagementEnabled: Bool = true
        private(set) var isMapEnabled: Bool = false
        private(set) var isVehicleIntergrationEnabled: Bool = false
        private(set) var hidePrices: Bool = false
        private(set) var menuItems: [MenuItem] = []

        var primaryBrandingColor: Color {
            .init(hex: primaryBrandingColorHex)
        }

        var secondaryBrandingColor: Color {
            .init(hex: secondaryBrandingColorHex)
        }
    }
}

extension ConfigurationManager.Configuration {
    struct MenuItem: Decodable {
        let name: String
        let url: String
        let languageCode: String
    }
}

extension ConfigurationManager.Configuration {
    enum CodingKeys: String, CodingKey {
        case clientId = "client_id"
        case primaryBrandingColorHex = "primary_branding_color"
        case secondaryBrandingColorHex = "secondary_branding_color"
        case isNativeFuelCardManagementEnabled = "native_fuelcard_management_enabled"
        case isMapEnabled = "map_enabled"
        case isVehicleIntergrationEnabled = "vehicle_integration_enabled"
        case hidePrices = "hide_prices"
        case menuItems = "menu_entry"
    }
}

extension ConfigurationManager.Configuration.MenuItem {
    enum CodingKeys: String, CodingKey {
        case name, url
        case languageCode = "language_code"
    }
}
