// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ColorAsset.Color", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetColorTypeAlias = ColorAsset.Color
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
  internal enum Colors {
    internal static let genericBlack = ColorAsset(name: "generic_black")
    internal static let genericGreen = ColorAsset(name: "generic_green")
    internal static let genericGrey = ColorAsset(name: "generic_grey")
    internal static let genericOrange = ColorAsset(name: "generic_orange")
    internal static let genericRed = ColorAsset(name: "generic_red")
    internal static let genericWhite = ColorAsset(name: "generic_white")
    internal static let genericYellow = ColorAsset(name: "generic_yellow")
    internal static let lightGrey = ColorAsset(name: "light_grey")
    internal static let shadow = ColorAsset(name: "shadow")
  }
  internal enum Images {
    internal static let detailArrowsOutward = ImageAsset(name: "detail_arrows_outward")
    internal static let detailBrandIcon = ImageAsset(name: "detail_brand_icon")
    internal static let gasStationListNoResults = ImageAsset(name: "gas_station_list_no_results")
    internal static let gasStationListPrimaryHeaderIcon = ImageAsset(name: "gas_station_list_primary_header_icon")
    internal static let mapCancel = ImageAsset(name: "map_cancel")
    internal static let mapFollowModeIcon = ImageAsset(name: "map_follow_mode_icon")
    internal static let mapFollowModeNoneIcon = ImageAsset(name: "map_follow_mode_none_icon")
    internal static let mapSearchIcon = ImageAsset(name: "map_search_icon")
    internal static let mapTabIcon = ImageAsset(name: "map_tab_icon")
    internal static let menuAnalyticsBlockIcon = ImageAsset(name: "menu_analytics_block_icon")
    internal static let menuAnalyticsCheckIcon = ImageAsset(name: "menu_analytics_check_icon")
    internal static let menuAnalyticsIcon = ImageAsset(name: "menu_analytics_icon")
    internal static let menuPermissionsIcon = ImageAsset(name: "menu_permissions_icon")
    internal static let menuPermissionsLocationIcon = ImageAsset(name: "menu_permissions_location_icon")
    internal static let menuPermissionsNotificationsIcon = ImageAsset(name: "menu_permissions_notifications_icon")
    internal static let menuDataPrivacyIcon = ImageAsset(name: "menu_data_privacy_icon")
    internal static let menuExternalSiteIcon = ImageAsset(name: "menu_external_site_icon")
    internal static let menuImprintIcon = ImageAsset(name: "menu_imprint_icon")
    internal static let menuTabIcon = ImageAsset(name: "menu_tab_icon")
    internal static let menuTermsIcon = ImageAsset(name: "menu_terms_icon")
    internal static let errorIcon = ImageAsset(name: "error_icon")
    internal static let noGasStationsIcon = ImageAsset(name: "no_gas_stations_icon")
    internal static let secondaryHeaderIcon = ImageAsset(name: "secondary_header_icon")
    internal static let warningIcon = ImageAsset(name: "warning_icon")
    internal static let onboardingAnalyticsIcon = ImageAsset(name: "onboarding_analytics_icon")
    internal static let onboardingBiometryIcon = ImageAsset(name: "onboarding_biometry_icon")
    internal static let onboardingFuelTypeIcon = ImageAsset(name: "onboarding_fuel_type_icon")
    internal static let onboardingLegalIcon = ImageAsset(name: "onboarding_legal_icon")
    internal static let onboardingLocationIcon = ImageAsset(name: "onboarding_location_icon")
    internal static let onboardingNotificationIcon = ImageAsset(name: "onboarding_notification_icon")
    internal static let onboardingPaymentMethodIcon = ImageAsset(name: "onboarding_payment_method_icon")
    internal static let onboardingPrimaryHeaderIcon = ImageAsset(name: "onboarding_primary_header_icon")
    internal static let onboardingSignInIcon = ImageAsset(name: "onboarding_sign_in_icon")
    internal static let walletAccountDeletionIcon = ImageAsset(name: "wallet_account_deletion_icon")
    internal static let walletAccountIcon = ImageAsset(name: "wallet_account_icon")
    internal static let walletArrowUpwardAlt = ImageAsset(name: "wallet_arrow_upward_alt")
    internal static let walletBonusIcon = ImageAsset(name: "wallet_bonus_icon")
    internal static let walletFuelTypeSelectionIcon = ImageAsset(name: "wallet_fuel_type_selection_icon")
    internal static let walletLocalGasStation = ImageAsset(name: "wallet_local_gas_station")
    internal static let walletLogoutIcon = ImageAsset(name: "wallet_logout_icon")
    internal static let walletTabIcon = ImageAsset(name: "wallet_tab_icon")
    internal static let walletTransactionsIcon = ImageAsset(name: "wallet_transactions_icon")
    internal static let walletTwoFactorAuthenticationIcon = ImageAsset(name: "wallet_two_factor_authentication_icon")
    internal static let walletTwoFactorAuthenticationPinIcon = ImageAsset(name: "wallet_two_factor_authentication_pin_icon")
    internal static let walletTwoFactorAuthenticatonBiometryIcon = ImageAsset(name: "wallet_two_factor_authenticaton_biometry_icon")
  }
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal final class ColorAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  internal private(set) lazy var color: Color = Color(asset: self)

  #if os(iOS) || os(tvOS)
  @available(iOS 11.0, tvOS 11.0, *)
  internal func color(compatibleWith traitCollection: UITraitCollection) -> Color {
    let bundle = BundleToken.bundle
    guard let color = Color(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }
  #endif

  fileprivate init(name: String) {
    self.name = name
  }
}

internal extension ColorAsset.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init!(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Image = UIImage
  #endif

  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, macOS 10.7, *)
  internal var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }

  #if os(iOS) || os(tvOS)
  @available(iOS 8.0, tvOS 9.0, *)
  internal func image(compatibleWith traitCollection: UITraitCollection) -> Image {
    let bundle = BundleToken.bundle
    guard let result = Image(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
  #endif
}

internal extension ImageAsset.Image {
  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, *)
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init!(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
