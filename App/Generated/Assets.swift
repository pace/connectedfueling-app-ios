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
    internal enum Feedback {
      internal static let danger = ColorAsset(name: "Feedback/Danger")
      internal static let info = ColorAsset(name: "Feedback/Info")
      internal static let neutral = ColorAsset(name: "Feedback/Neutral")
      internal static let success = ColorAsset(name: "Feedback/Success")
      internal static let warning = ColorAsset(name: "Feedback/Warning")
    }
    internal enum Text {
      internal static let darkText = ColorAsset(name: "Text/DarkText")
      internal static let lightText = ColorAsset(name: "Text/LightText")
    }
    internal enum Theme {
      internal static let accent = ColorAsset(name: "Theme/Accent")
      internal static let background = ColorAsset(name: "Theme/Background")
      internal static let backgroundGray = ColorAsset(name: "Theme/BackgroundGray")
      internal static let backgroundLightGray = ColorAsset(name: "Theme/BackgroundLightGray")
      internal static let disabled = ColorAsset(name: "Theme/Disabled")
      internal static let lightButtonShadow = ColorAsset(name: "Theme/LightButtonShadow")
      internal static let lightShadow = ColorAsset(name: "Theme/LightShadow")
      internal static let pageIndicatorBackground = ColorAsset(name: "Theme/PageIndicatorBackground")
      internal static let pageIndicatorForeground = ColorAsset(name: "Theme/PageIndicatorForeground")
      internal static let primary = ColorAsset(name: "Theme/Primary")
      internal static let secondary = ColorAsset(name: "Theme/Secondary")
      internal static let shadow = ColorAsset(name: "Theme/Shadow")
      internal static let buttonShadow = ColorAsset(name: "Theme/buttonShadow")
    }
  }
  internal enum Images {
    internal static let closeIcon = ImageAsset(name: "CloseIcon")
    internal static let fuelPump = ImageAsset(name: "FuelPump")
    internal static let gasStationLogo = ImageAsset(name: "GasStationLogo")
    internal static let navigation = ImageAsset(name: "Navigation")
    internal static let noResults = ImageAsset(name: "NoResults")
    internal static let route = ImageAsset(name: "Route")
    internal static let logo = ImageAsset(name: "Logo")
    internal static let menu = ImageAsset(name: "Menu")
    internal enum MenuItems {
      internal static let fuelType = ImageAsset(name: "MenuItems/FuelType")
      internal static let imprint = ImageAsset(name: "MenuItems/Imprint")
      internal static let logout = ImageAsset(name: "MenuItems/Logout")
      internal static let paymentHistory = ImageAsset(name: "MenuItems/PaymentHistory")
      internal static let paymentMethods = ImageAsset(name: "MenuItems/PaymentMethods")
      internal static let privacyPolicy = ImageAsset(name: "MenuItems/PrivacyPolicy")
      internal static let profile = ImageAsset(name: "MenuItems/Profile")
    }
    internal static let biometry = ImageAsset(name: "Biometry")
    internal static let fuelType = ImageAsset(name: "FuelType")
    internal static let location = ImageAsset(name: "Location")
    internal static let paymentMethod = ImageAsset(name: "PaymentMethod")
    internal static let profile = ImageAsset(name: "Profile")
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
      fatalError("Unable to load image named \(name).")
    }
    return result
  }
}

internal extension ImageAsset.Image {
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
