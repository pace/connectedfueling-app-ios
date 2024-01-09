import SwiftUI

extension ConfigurationManager {
    struct Configuration: Decodable {
        let clientId: String
        let primaryBrandingColorHex: String
        let secondaryBrandingColorHex: String
        let isAnalyticsEnabled: Bool

        private(set) var onboardingStyle: OnboardingStyle = .secondary
        private(set) var gasStationListStyle: GasStationListStyle = .secondary
        private(set) var textButtonsColorHex: String?
        private(set) var isNativeFuelCardManagementEnabled: Bool = true
        private(set) var isMapEnabled: Bool = false
        private(set) var isVehicleIntergrationEnabled: Bool = false
        private(set) var hidePrices: Bool = false
        private(set) var menuEntries: [MenuEntry]?

        var primaryBrandingColor: Color {
            .init(hex: primaryBrandingColorHex)
        }

        var secondaryBrandingColor: Color {
            .init(hex: secondaryBrandingColorHex)
        }

        var textButtonsColor: Color {
            guard let textButtonsColorHex else { return primaryBrandingColor.contrastColor }
            return .init(hex: textButtonsColorHex)
        }
    }
}

extension ConfigurationManager.Configuration {
    enum OnboardingStyle: String, Decodable {
        case primary
        case secondary
    }

    enum GasStationListStyle: String, Decodable {
        case primary
        case secondary
    }

    struct MenuEntry: Decodable {
        let menuEntryId: MenuEntryId
    }
}

extension ConfigurationManager.Configuration.MenuEntry {
    struct MenuEntryId: Decodable {
        let menuItems: [MenuItem]
    }
}

extension ConfigurationManager.Configuration.MenuEntry.MenuEntryId {
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
        case isAnalyticsEnabled = "analytics_enabled"
        case onboardingStyle = "onboarding_style"
        case gasStationListStyle = "gas_station_list_style"
        case textButtonsColorHex = "text_buttons_color"
        case isNativeFuelCardManagementEnabled = "native_fuelcard_management_enabled"
        case isMapEnabled = "map_enabled"
        case isVehicleIntergrationEnabled = "vehicle_integration_enabled"
        case hidePrices = "hide_prices"
        case menuEntries = "menu_entries"
    }
}

extension ConfigurationManager.Configuration.MenuEntry {
    enum CodingKeys: String, CodingKey {
        case menuEntryId = "menu_entries_id"
    }
}

extension ConfigurationManager.Configuration.MenuEntry.MenuEntryId {
    enum CodingKeys: String, CodingKey {
        case menuItems = "menu_entry"
    }
}

extension ConfigurationManager.Configuration.MenuEntry.MenuEntryId.MenuItem {
    enum CodingKeys: String, CodingKey {
        case name, url
        case languageCode = "languages_code"
    }
}
