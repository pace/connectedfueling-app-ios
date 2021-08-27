// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {

  internal enum Alert {
    internal enum LocationPermission {
      /// To show you the nearest gas station, we need access to your current location.
      internal static let description = L10n.tr("Localizable", "ALERT.LOCATION_PERMISSION.DESCRIPTION")
      /// Location permission not granted
      internal static let title = L10n.tr("Localizable", "ALERT.LOCATION_PERMISSION.TITLE")
      internal enum Actions {
        /// Open settings
        internal static let openSettings = L10n.tr("Localizable", "ALERT.LOCATION_PERMISSION.ACTIONS.OPEN_SETTINGS")
      }
    }
  }

  internal enum Dashboard {
    internal enum Actions {
      /// NAVIGATE TO
      internal static let navigate = L10n.tr("Localizable", "DASHBOARD.ACTIONS.NAVIGATE")
      /// FUEL HERE
      internal static let startFueling = L10n.tr("Localizable", "DASHBOARD.ACTIONS.START_FUELING")
    }
    internal enum EmptyView {
      /// No gas stations where found nearby your location.
      internal static let description = L10n.tr("Localizable", "DASHBOARD.EMPTY_VIEW.DESCRIPTION")
      /// No gas stations nearby
      internal static let title = L10n.tr("Localizable", "DASHBOARD.EMPTY_VIEW.TITLE")
    }
    internal enum LoadingView {
      /// We are searching for the nearest gas stations in your area. This may take a moment.
      internal static let description = L10n.tr("Localizable", "DASHBOARD.LOADING_VIEW.DESCRIPTION")
      /// Searching gas stations...
      internal static let title = L10n.tr("Localizable", "DASHBOARD.LOADING_VIEW.TITLE")
    }
    internal enum Logout {
      internal enum Confirm {
        /// Your data will still be saved in your PACE-ID account.
        internal static let description = L10n.tr("Localizable", "DASHBOARD.LOGOUT.CONFIRM.DESCRIPTION")
        /// Do you really want to logout?
        internal static let title = L10n.tr("Localizable", "DASHBOARD.LOGOUT.CONFIRM.TITLE")
        internal enum Action {
          /// CANCEL
          internal static let cancel = L10n.tr("Localizable", "DASHBOARD.LOGOUT.CONFIRM.ACTION.CANCEL")
          /// LOGOUT
          internal static let logout = L10n.tr("Localizable", "DASHBOARD.LOGOUT.CONFIRM.ACTION.LOGOUT")
        }
      }
    }
    internal enum Sections {
      /// Nearest gas station
      internal static let nearestGasStation = L10n.tr("Localizable", "DASHBOARD.SECTIONS.NEAREST_GAS_STATION")
      /// Other gas stations
      internal static let otherGasStations = L10n.tr("Localizable", "DASHBOARD.SECTIONS.OTHER_GAS_STATIONS")
    }
  }

  internal enum FuelType {
    /// DIESEL
    internal static let diesel = L10n.tr("Localizable", "FUEL_TYPE.DIESEL")
    /// SUPER
    internal static let `super` = L10n.tr("Localizable", "FUEL_TYPE.SUPER")
    /// SUPER E10
    internal static let superE10 = L10n.tr("Localizable", "FUEL_TYPE.SUPER_E10")
    /// SUPER PLUS
    internal static let superPlus = L10n.tr("Localizable", "FUEL_TYPE.SUPER_PLUS")
  }

  internal enum Global {
    internal enum Actions {
      /// Close
      internal static let close = L10n.tr("Localizable", "GLOBAL.ACTIONS.CLOSE")
    }
  }

  internal enum Menu {
    internal enum Items {
      /// Change fuel type
      internal static let fuelType = L10n.tr("Localizable", "MENU.ITEMS.FUEL_TYPE")
      /// Legal Notice
      internal static let imprint = L10n.tr("Localizable", "MENU.ITEMS.IMPRINT")
      /// Logout
      internal static let logout = L10n.tr("Localizable", "MENU.ITEMS.LOGOUT")
      /// Show payment history
      internal static let paymentHistory = L10n.tr("Localizable", "MENU.ITEMS.PAYMENT_HISTORY")
      /// Edit payment methods
      internal static let paymentMethods = L10n.tr("Localizable", "MENU.ITEMS.PAYMENT_METHODS")
      /// Privacy Statement
      internal static let privacy = L10n.tr("Localizable", "MENU.ITEMS.PRIVACY")
    }
    internal enum Title {
      /// PACE Connected Fueling
      internal static let placeholder = L10n.tr("Localizable", "MENU.TITLE.PLACEHOLDER")
    }
  }

  internal enum Onboarding {
    internal enum Actions {
      /// ADD PAYMENT METHOD
      internal static let addPaymentMethod = L10n.tr("Localizable", "ONBOARDING.ACTIONS.ADD_PAYMENT_METHOD")
      /// LOGIN OR REGISTER
      internal static let authenticate = L10n.tr("Localizable", "ONBOARDING.ACTIONS.AUTHENTICATE")
      /// GO!
      internal static let complete = L10n.tr("Localizable", "ONBOARDING.ACTIONS.COMPLETE")
      /// NEXT
      internal static let next = L10n.tr("Localizable", "ONBOARDING.ACTIONS.NEXT")
      /// ALLOW LOCATION ACCESS
      internal static let shareLocation = L10n.tr("Localizable", "ONBOARDING.ACTIONS.SHARE_LOCATION")
      /// Skip
      internal static let skip = L10n.tr("Localizable", "ONBOARDING.ACTIONS.SKIP")
    }
    internal enum Authentication {
      /// For easy payment with the app you have to register or login with your existing PACE-ID.
      internal static let description = L10n.tr("Localizable", "ONBOARDING.AUTHENTICATION.DESCRIPTION")
      /// Add profile
      internal static let title = L10n.tr("Localizable", "ONBOARDING.AUTHENTICATION.TITLE")
    }
    internal enum CreatePin {
      /// NEXT
      internal static let confirm = L10n.tr("Localizable", "ONBOARDING.CREATE_PIN.CONFIRM")
      /// Choose a 4-digit PIN that can be used to authorise payments.
      internal static let description = L10n.tr("Localizable", "ONBOARDING.CREATE_PIN.DESCRIPTION")
      /// Choose pin
      internal static let title = L10n.tr("Localizable", "ONBOARDING.CREATE_PIN.TITLE")
    }
    internal enum EnterOneTimePassword {
      /// CONFIRM
      internal static let confirm = L10n.tr("Localizable", "ONBOARDING.ENTER_ONE_TIME_PASSWORD.CONFIRM")
      /// Please authorize the change with the confirmation code from your email inbox.
      internal static let description = L10n.tr("Localizable", "ONBOARDING.ENTER_ONE_TIME_PASSWORD.DESCRIPTION")
      /// Enter confirmation code
      internal static let title = L10n.tr("Localizable", "ONBOARDING.ENTER_ONE_TIME_PASSWORD.TITLE")
    }
    internal enum FuelType {
      /// And finally: What fuel prices should we show you?
      internal static let description = L10n.tr("Localizable", "ONBOARDING.FUEL_TYPE.DESCRIPTION")
      /// Fuel type
      internal static let title = L10n.tr("Localizable", "ONBOARDING.FUEL_TYPE.TITLE")
    }
    internal enum PaymentMethod {
      /// Select a payment method to start your first refueling.
      internal static let description = L10n.tr("Localizable", "ONBOARDING.PAYMENT_METHOD.DESCRIPTION")
      /// Payment method
      internal static let title = L10n.tr("Localizable", "ONBOARDING.PAYMENT_METHOD.TITLE")
    }
    internal enum Permission {
      /// To show you the closest gas stations, we need to access your location.
      internal static let description = L10n.tr("Localizable", "ONBOARDING.PERMISSION.DESCRIPTION")
      /// Gas stations near you
      internal static let title = L10n.tr("Localizable", "ONBOARDING.PERMISSION.TITLE")
    }
    internal enum Pin {
      internal enum Error {
        /// The PIN needs to be a 4-digit number.
        internal static let invalidLength = L10n.tr("Localizable", "ONBOARDING.PIN.ERROR.INVALID_LENGTH")
        /// The PINs don't match. Try again.
        internal static let mismatch = L10n.tr("Localizable", "ONBOARDING.PIN.ERROR.MISMATCH")
        /// The PIN is too simple (0000 or 1234 are not allowed). Choose a different PIN.
        internal static let notSecure = L10n.tr("Localizable", "ONBOARDING.PIN.ERROR.NOT_SECURE")
        /// The PIN can't be a series of ascending or descending numbers.
        internal static let series = L10n.tr("Localizable", "ONBOARDING.PIN.ERROR.SERIES")
        /// The PIN needs to contain at least three distinct digits.
        internal static let tooFewDigits = L10n.tr("Localizable", "ONBOARDING.PIN.ERROR.TOO_FEW_DIGITS")
      }
    }
    internal enum TwoFactorAuthentication {
      /// BIOMETRY
      internal static let biometry = L10n.tr("Localizable", "ONBOARDING.TWO_FACTOR_AUTHENTICATION.BIOMETRY")
      /// Biometric scanners are the fastest and most secure way to confirm your payment transactions.
      internal static let description = L10n.tr("Localizable", "ONBOARDING.TWO_FACTOR_AUTHENTICATION.DESCRIPTION")
      /// Choose PIN
      internal static let pin = L10n.tr("Localizable", "ONBOARDING.TWO_FACTOR_AUTHENTICATION.PIN")
      /// Secure and fast payment
      internal static let title = L10n.tr("Localizable", "ONBOARDING.TWO_FACTOR_AUTHENTICATION.TITLE")
    }
    internal enum VerifyPin {
      /// NEXT
      internal static let confirm = L10n.tr("Localizable", "ONBOARDING.VERIFY_PIN.CONFIRM")
      /// Please re-enter the PIN for confirmation.
      internal static let description = L10n.tr("Localizable", "ONBOARDING.VERIFY_PIN.DESCRIPTION")
      /// Confirm pin
      internal static let title = L10n.tr("Localizable", "ONBOARDING.VERIFY_PIN.TITLE")
    }
  }

  internal enum Price {
    /// n. a.
    internal static let notAvailable = L10n.tr("Localizable", "PRICE.NOT_AVAILABLE")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
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
