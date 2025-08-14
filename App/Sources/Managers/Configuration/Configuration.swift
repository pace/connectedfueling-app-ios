import SwiftUI

extension ConfigurationManager {
    struct Configuration: Decodable {
        let clientId: String
        let primaryBrandingColorHex: String
        let secondaryBrandingColorHex: String
        let isAnalyticsEnabled: Bool

        private(set) var onboardingStyle: OnboardingStyle = .secondary
        private(set) var gasStationListStyle: GasStationListStyle = .secondary
        private(set) var detailViewStyle: DetailViewStyle = .secondary
        private(set) var textButtonsColorHex: String?
        private(set) var isNativeFuelCardManagementEnabled: Bool = true
        private(set) var isMapEnabled: Bool = false
        private(set) var isVehicleIntergrationEnabled: Bool = false
        private(set) var hidePrices: Bool = false
        private(set) var menuEntries: [MenuEntry]?
        
        private(set) var tokenExchange: TokenExchange?
        private(set) var externalOIDC: ExternalOIDC?

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
    struct TokenExchange: Decodable {
        let clientId: String
        let issuerId: String
        let clientSecret: String?
        
        init(clientId: String, issuerId: String, clientSecret: String) {
            self.clientId = clientId
            self.issuerId = issuerId
            self.clientSecret = clientSecret
        }
        
        init(from decoder: any Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            self.clientId = try values.decode(String.self, forKey: .clientId)
            self.issuerId = try values.decode(String.self, forKey: .issuerId)
            self.clientSecret = try values.decodeIfPresent(String.self, forKey: .clientSecret)
        }
    }
}

extension ConfigurationManager.Configuration {
    struct ExternalOIDC: Decodable {
        let authEndpoint: String
        let tokenEndpoint: String
        let endSessionEndpoint: String
        let clientSecret: String
        let redirectUri: String
        let accountDeletionUrl: String
        
        init(authEndpoint: String, tokenEndpoint: String, endSessionEndpoint: String, clientSecret: String, redirectUri: String, accountDeletionUrl: String) {
            self.authEndpoint = authEndpoint
            self.tokenEndpoint = tokenEndpoint
            self.endSessionEndpoint = endSessionEndpoint
            self.clientSecret = clientSecret
            self.redirectUri = redirectUri
            self.accountDeletionUrl = accountDeletionUrl
        }
        
        init(from decoder: any Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            self.authEndpoint = try values.decode(String.self, forKey: .authEndpoint)
            self.tokenEndpoint = try values.decode(String.self, forKey: .tokenEndpoint)
            self.endSessionEndpoint = try values.decode(String.self, forKey: .endSessionEndpoint)
            self.clientSecret = try values.decode(String.self, forKey: .clientSecret)
            self.redirectUri = try values.decode(String.self, forKey: .redirectUri)
            self.accountDeletionUrl = try values.decode(String.self, forKey: .accountDeletionUrl)
        }
    }
}

extension ConfigurationManager.Configuration.TokenExchange {
    enum CodingKeys: String, CodingKey {
        case clientId = "client_id"
        case issuerId = "issuer_id"
        case clientSecret = "client_secret"
    }
}

extension ConfigurationManager.Configuration.ExternalOIDC {
    enum CodingKeys: String, CodingKey {
        case authEndpoint = "auth_endpoint"
        case tokenEndpoint = "token_endpoint"
        case endSessionEndpoint = "end_session_endpoint"
        case clientSecret = "client_secret"
        case redirectUri = "redirect_uri"
        case accountDeletionUrl = "account_deletion_url"
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

    enum DetailViewStyle: String, Decodable {
        case primary
        case secondary
    }

    struct MenuEntry: Decodable {
        let menuEntryId: MenuEntryId
    }
}

extension ConfigurationManager.Configuration.MenuEntry {
    struct MenuEntryId: Decodable {
        let id: String
        let menuItems: [MenuItem]
    }
}

extension ConfigurationManager.Configuration.MenuEntry.MenuEntryId {
    struct MenuItem: Decodable {
        let name: String
        let url: String?
        let html: HTML?
        let languageCode: String

        var hasHtml: Bool {
            html != nil
        }

        init(name: String,
             url: String?,
             html: HTML?,
             languageCode: String) {
            self.name = name
            self.url = url
            self.html = html
            self.languageCode = languageCode
        }

        init(from decoder: any Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            self.name = try values.decode(String.self, forKey: .name)
            self.url = try values.decodeIfPresent(String.self, forKey: .url)
            self.html = try values.decodeIfPresent(ConfigurationManager.Configuration.MenuEntry.MenuEntryId.MenuItem.HTML.self, forKey: .html)
            self.languageCode = try values.decode(String.self, forKey: .languageCode)
        }
    }
}

extension ConfigurationManager.Configuration.MenuEntry.MenuEntryId.MenuItem {
    struct HTML: Decodable {
        let id: String
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
        case detailViewStyle = "detail_view_style"
        case textButtonsColorHex = "text_buttons_color"
        case isNativeFuelCardManagementEnabled = "native_fuelcard_management_enabled"
        case isMapEnabled = "map_enabled"
        case isVehicleIntergrationEnabled = "vehicle_integration_enabled"
        case hidePrices = "hide_prices"
        case menuEntries = "menu_entries"
        case tokenExchange = "token_exchange"
        case externalOIDC = "external_oidc"
    }
}

extension ConfigurationManager.Configuration.MenuEntry {
    enum CodingKeys: String, CodingKey {
        case menuEntryId = "menu_entries_id"
    }
}

extension ConfigurationManager.Configuration.MenuEntry.MenuEntryId {
    enum CodingKeys: String, CodingKey {
        case id
        case menuItems = "menu_entry"
    }
}

extension ConfigurationManager.Configuration.MenuEntry.MenuEntryId.MenuItem {
    enum CodingKeys: String, CodingKey {
        case name, url, html
        case languageCode = "languages_code"
    }
}
