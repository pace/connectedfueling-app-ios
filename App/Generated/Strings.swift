// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// Try again
  internal static let commonRetry = L10n.tr("Localizable", "common_retry", fallback: "Try again")
  /// %2$@%1$@
  internal static func currencyFormat(_ p1: Any, _ p2: Any) -> String {
    return L10n.tr("Localizable", "currency_format", String(describing: p1), String(describing: p2), fallback: "%2$@%1$@")
  }
  /// Diesel
  internal static let fuelGroupDiesel = L10n.tr("Localizable", "fuel_group_diesel", fallback: "Diesel")
  /// Petrol
  internal static let fuelGroupPetrol = L10n.tr("Localizable", "fuel_group_petrol", fallback: "Petrol")
  /// Fuel selection
  internal static let fuelSelectionTitle = L10n.tr("Localizable", "fuel_selection_title", fallback: "Fuel selection")
  /// What fuel prices should we show you?
  internal static let fuelTypeSelection = L10n.tr("Localizable", "FUEL_TYPE_SELECTION", fallback: "What fuel prices should we show you?")
  /// Loading failed
  internal static let generalErrorTitle = L10n.tr("Localizable", "general_error_title", fallback: "Loading failed")
  /// List
  internal static let listTabLabel = L10n.tr("Localizable", "list_tab_label", fallback: "List")
  /// More
  internal static let moreTabLabel = L10n.tr("Localizable", "more_tab_label", fallback: "More")
  /// Apple Pay
  internal static let paymentMethodKindApplepay = L10n.tr("Localizable", "payment_method_kind_applepay", fallback: "Apple Pay")
  /// Credit card
  internal static let paymentMethodKindCreditCard = L10n.tr("Localizable", "payment_method_kind_credit_card", fallback: "Credit card")
  /// Credit card
  internal static let paymentMethodKindCreditcard = L10n.tr("Localizable", "payment_method_kind_creditcard", fallback: "Credit card")
  /// DKV Card
  internal static let paymentMethodKindDkv = L10n.tr("Localizable", "payment_method_kind_dkv", fallback: "DKV Card")
  /// Fuel card
  internal static let paymentMethodKindFuelCard = L10n.tr("Localizable", "payment_method_kind_fuel_card", fallback: "Fuel card")
  /// giropay
  internal static let paymentMethodKindGiropay = L10n.tr("Localizable", "payment_method_kind_giropay", fallback: "giropay")
  /// HoyerCard
  internal static let paymentMethodKindHoyer = L10n.tr("Localizable", "payment_method_kind_hoyer", fallback: "HoyerCard")
  /// PayPal
  internal static let paymentMethodKindPaypal = L10n.tr("Localizable", "payment_method_kind_paypal", fallback: "PayPal")
  /// SEPA direct debit
  internal static let paymentMethodKindSepa = L10n.tr("Localizable", "payment_method_kind_sepa", fallback: "SEPA direct debit")
  /// ZGM Card
  internal static let paymentMethodKindZgm = L10n.tr("Localizable", "payment_method_kind_zgm", fallback: "ZGM Card")
  /// Add
  internal static let paymentMethodsAddButton = L10n.tr("Localizable", "payment_methods_add_button", fallback: "Add")
  /// Add a payment method or fuel card so that you can start your first refueling process
  internal static let paymentMethodsEmptyDescription = L10n.tr("Localizable", "payment_methods_empty_description", fallback: "Add a payment method or fuel card so that you can start your first refueling process")
  /// No payment methods or fuel cards
  internal static let paymentMethodsEmptyTitle = L10n.tr("Localizable", "payment_methods_empty_title", fallback: "No payment methods or fuel cards")
  /// Your payment methods and fuel cards could not be loaded. Check your connection!
  internal static let paymentMethodsErrorDescription = L10n.tr("Localizable", "payment_methods_error_description", fallback: "Your payment methods and fuel cards could not be loaded. Check your connection!")
  /// We load your payment methods and fuel cards. Please wait a moment.
  internal static let paymentMethodsLoadingDescription = L10n.tr("Localizable", "payment_methods_loading_description", fallback: "We load your payment methods and fuel cards. Please wait a moment.")
  /// Loading payment methods and fuel cards…
  internal static let paymentMethodsLoadingTitle = L10n.tr("Localizable", "payment_methods_loading_title", fallback: "Loading payment methods and fuel cards…")
  /// Payment methods & fuel cards
  internal static let paymentMethodsTitle = L10n.tr("Localizable", "payment_methods_title", fallback: "Payment methods & fuel cards")
  /// Share
  internal static let shareTitle = L10n.tr("Localizable", "SHARE_TITLE", fallback: "Share")
  /// Transactions
  internal static let transactionsTitle = L10n.tr("Localizable", "transactions_title", fallback: "Transactions")
  /// You are logged in as
  internal static let walletHeaderText = L10n.tr("Localizable", "wallet_header_text", fallback: "You are logged in as")
  /// Wallet
  internal static let walletTabLabel = L10n.tr("Localizable", "wallet_tab_label", fallback: "Wallet")
  internal enum Alert {
    internal enum LocationPermission {
      /// To show you the nearest gas station, we need access to your current location.
      internal static let description = L10n.tr("Localizable", "ALERT.LOCATION_PERMISSION.DESCRIPTION", fallback: "To show you the nearest gas station, we need access to your current location.")
      /// Location permission not granted
      internal static let title = L10n.tr("Localizable", "ALERT.LOCATION_PERMISSION.TITLE", fallback: "Location permission not granted")
      internal enum Actions {
        /// Open settings
        internal static let openSettings = L10n.tr("Localizable", "ALERT.LOCATION_PERMISSION.ACTIONS.OPEN_SETTINGS", fallback: "Open settings")
      }
    }
  }
  internal enum Dashboard {
    internal enum Actions {
      /// NAVIGATE TO
      internal static let navigate = L10n.tr("Localizable", "DASHBOARD.ACTIONS.NAVIGATE", fallback: "NAVIGATE TO")
      /// FUEL HERE
      internal static let startFueling = L10n.tr("Localizable", "DASHBOARD.ACTIONS.START_FUELING", fallback: "FUEL HERE")
    }
    internal enum EmptyView {
      /// No gas stations where found nearby your location.
      internal static let description = L10n.tr("Localizable", "DASHBOARD.EMPTY_VIEW.DESCRIPTION", fallback: "No gas stations where found nearby your location.")
      /// No gas stations nearby
      internal static let title = L10n.tr("Localizable", "DASHBOARD.EMPTY_VIEW.TITLE", fallback: "No gas stations nearby")
    }
    internal enum LoadingView {
      /// We are searching for the nearest gas stations in your area. This may take a moment.
      internal static let description = L10n.tr("Localizable", "DASHBOARD.LOADING_VIEW.DESCRIPTION", fallback: "We are searching for the nearest gas stations in your area. This may take a moment.")
      /// Searching gas stations...
      internal static let title = L10n.tr("Localizable", "DASHBOARD.LOADING_VIEW.TITLE", fallback: "Searching gas stations...")
    }
    internal enum Logout {
      internal enum Confirm {
        /// Your data will still be saved in your PACE-ID account.
        internal static let description = L10n.tr("Localizable", "DASHBOARD.LOGOUT.CONFIRM.DESCRIPTION", fallback: "Your data will still be saved in your PACE-ID account.")
        /// Do you really want to logout?
        internal static let title = L10n.tr("Localizable", "DASHBOARD.LOGOUT.CONFIRM.TITLE", fallback: "Do you really want to logout?")
        internal enum Action {
          /// CANCEL
          internal static let cancel = L10n.tr("Localizable", "DASHBOARD.LOGOUT.CONFIRM.ACTION.CANCEL", fallback: "CANCEL")
          /// LOGOUT
          internal static let logout = L10n.tr("Localizable", "DASHBOARD.LOGOUT.CONFIRM.ACTION.LOGOUT", fallback: "LOGOUT")
        }
      }
    }
    internal enum Sections {
      /// Nearest gas station
      internal static let nearestGasStation = L10n.tr("Localizable", "DASHBOARD.SECTIONS.NEAREST_GAS_STATION", fallback: "Nearest gas station")
      /// Other gas stations
      internal static let otherGasStations = L10n.tr("Localizable", "DASHBOARD.SECTIONS.OTHER_GAS_STATIONS", fallback: "Other gas stations")
    }
  }
  internal enum FuelType {
    /// DIESEL
    internal static let diesel = L10n.tr("Localizable", "FUEL_TYPE.DIESEL", fallback: "DIESEL")
    /// SUPER
    internal static let `super` = L10n.tr("Localizable", "FUEL_TYPE.SUPER", fallback: "SUPER")
    /// SUPER E10
    internal static let superE10 = L10n.tr("Localizable", "FUEL_TYPE.SUPER_E10", fallback: "SUPER E10")
    /// SUPER PLUS
    internal static let superPlus = L10n.tr("Localizable", "FUEL_TYPE.SUPER_PLUS", fallback: "SUPER PLUS")
  }
  internal enum Global {
    internal enum Actions {
      /// Close
      internal static let close = L10n.tr("Localizable", "GLOBAL.ACTIONS.CLOSE", fallback: "Close")
    }
  }
  internal enum Home {
    /// Gas stations could not be loaded. Check your connection!
    internal static let loadingFailedText = L10n.tr("Localizable", "HOME.LOADING_FAILED_TEXT", fallback: "Gas stations could not be loaded. Check your connection!")
    /// We are currently locating you. This might take a moment.
    internal static let lookingForLocationText = L10n.tr("Localizable", "HOME.LOOKING_FOR_LOCATION_TEXT", fallback: "We are currently locating you. This might take a moment.")
    /// Looking for location…
    internal static let lookingForLocationTitle = L10n.tr("Localizable", "HOME.LOOKING_FOR_LOCATION_TITLE", fallback: "Looking for location…")
    /// For this gas station and your fuel type there are currently no prices available.
    internal static let priceNotAvailableDescription = L10n.tr("Localizable", "HOME.PRICE_NOT_AVAILABLE_DESCRIPTION", fallback: "For this gas station and your fuel type there are currently no prices available.")
  }
  internal enum LocationDialog {
    /// To show you petrol stations near you, location services must be enabled.
    internal static let disabledText = L10n.tr("Localizable", "LOCATION_DIALOG.DISABLED_TEXT", fallback: "To show you petrol stations near you, location services must be enabled.")
    /// Location services disabled
    internal static let disabledTitle = L10n.tr("Localizable", "LOCATION_DIALOG.DISABLED_TITLE", fallback: "Location services disabled")
    /// To show you the nearest gas station, we need access to your current location.
    internal static let permissionDeniedText = L10n.tr("Localizable", "LOCATION_DIALOG.PERMISSION_DENIED_TEXT", fallback: "To show you the nearest gas station, we need access to your current location.")
    /// Location permission not granted
    internal static let permissionDeniedTitle = L10n.tr("Localizable", "LOCATION_DIALOG.PERMISSION_DENIED_TITLE", fallback: "Location permission not granted")
  }
  internal enum Menu {
    internal enum Items {
      /// Contact us
      internal static let contact = L10n.tr("Localizable", "MENU.ITEMS.CONTACT", fallback: "Contact us")
      /// Change fuel type
      internal static let fuelType = L10n.tr("Localizable", "MENU.ITEMS.FUEL_TYPE", fallback: "Change fuel type")
      /// Legal Notice
      internal static let imprint = L10n.tr("Localizable", "MENU.ITEMS.IMPRINT", fallback: "Legal Notice")
      /// Licenses
      internal static let licences = L10n.tr("Localizable", "MENU.ITEMS.LICENCES", fallback: "Licenses")
      /// Logout
      internal static let logout = L10n.tr("Localizable", "MENU.ITEMS.LOGOUT", fallback: "Logout")
      /// Show payment history
      internal static let paymentHistory = L10n.tr("Localizable", "MENU.ITEMS.PAYMENT_HISTORY", fallback: "Show payment history")
      /// Edit payment methods
      internal static let paymentMethods = L10n.tr("Localizable", "MENU.ITEMS.PAYMENT_METHODS", fallback: "Edit payment methods")
      /// Privacy Statement
      internal static let privacy = L10n.tr("Localizable", "MENU.ITEMS.PRIVACY", fallback: "Privacy Statement")
      /// Terms of Use
      internal static let terms = L10n.tr("Localizable", "MENU.ITEMS.TERMS", fallback: "Terms of Use")
    }
    internal enum Title {
      /// PACE Connected Fueling
      internal static let placeholder = L10n.tr("Localizable", "MENU.TITLE.PLACEHOLDER", fallback: "PACE Connected Fueling")
    }
  }
  internal enum Onboarding {
    /// Your input could not be verified. Try again.
    internal static let errorAuthorisation = L10n.tr("Localizable", "ONBOARDING.ERROR_AUTHORISATION", fallback: "Your input could not be verified. Try again.")
    /// Error recognizing fingerprint: %s
    internal static func fingerprintError(_ p1: UnsafePointer<CChar>) -> String {
      return L10n.tr("Localizable", "ONBOARDING.FINGERPRINT_ERROR", p1, fallback: "Error recognizing fingerprint: %s")
    }
    /// Currently there are no saved fingerprints!
    internal static let fingerprintNoneSavedTitle = L10n.tr("Localizable", "ONBOARDING.FINGERPRINT_NONE_SAVED_TITLE", fallback: "Currently there are no saved fingerprints!")
    /// Add now
    internal static let fingerprintSave = L10n.tr("Localizable", "ONBOARDING.FINGERPRINT_SAVE", fallback: "Add now")
    /// Please select a fuel type.
    internal static let fuelTypeUnselectedText = L10n.tr("Localizable", "ONBOARDING.FUEL_TYPE_UNSELECTED_TEXT", fallback: "Please select a fuel type.")
    /// Your session is expired.
    internal static let invalidSession = L10n.tr("Localizable", "ONBOARDING.INVALID_SESSION", fallback: "Your session is expired.")
    /// Login failed. Without an account, paying your fuel with your smartphone is not possible.
    internal static let logInUnsuccessful = L10n.tr("Localizable", "ONBOARDING.LOG_IN_UNSUCCESSFUL", fallback: "Login failed. Without an account, paying your fuel with your smartphone is not possible.")
    /// Connecting to the internet failed. Try again later.
    internal static let networkError = L10n.tr("Localizable", "ONBOARDING.NETWORK_ERROR", fallback: "Connecting to the internet failed. Try again later.")
    /// Retry login
    internal static let retryLogin = L10n.tr("Localizable", "ONBOARDING.RETRY_LOGIN", fallback: "Retry login")
    /// An unknown error occurred. Try again later.
    internal static let unknownError = L10n.tr("Localizable", "ONBOARDING.UNKNOWN_ERROR", fallback: "An unknown error occurred. Try again later.")
    internal enum Actions {
      /// ADD PAYMENT METHOD
      internal static let addPaymentMethod = L10n.tr("Localizable", "ONBOARDING.ACTIONS.ADD_PAYMENT_METHOD", fallback: "ADD PAYMENT METHOD")
      /// LOGIN OR REGISTER
      internal static let authenticate = L10n.tr("Localizable", "ONBOARDING.ACTIONS.AUTHENTICATE", fallback: "LOGIN OR REGISTER")
      /// BACK
      internal static let back = L10n.tr("Localizable", "ONBOARDING.ACTIONS.BACK", fallback: "BACK")
      /// GO!
      internal static let complete = L10n.tr("Localizable", "ONBOARDING.ACTIONS.COMPLETE", fallback: "GO!")
      /// NEXT
      internal static let next = L10n.tr("Localizable", "ONBOARDING.ACTIONS.NEXT", fallback: "NEXT")
      /// SAVE
      internal static let save = L10n.tr("Localizable", "ONBOARDING.ACTIONS.SAVE", fallback: "SAVE")
      /// ALLOW LOCATION ACCESS
      internal static let shareLocation = L10n.tr("Localizable", "ONBOARDING.ACTIONS.SHARE_LOCATION", fallback: "ALLOW LOCATION ACCESS")
      /// Skip
      internal static let skip = L10n.tr("Localizable", "ONBOARDING.ACTIONS.SKIP", fallback: "Skip")
    }
    internal enum Authentication {
      /// For easy payment with the app you have to register or login with your existing PACE-ID.
      internal static let description = L10n.tr("Localizable", "ONBOARDING.AUTHENTICATION.DESCRIPTION", fallback: "For easy payment with the app you have to register or login with your existing PACE-ID.")
      /// Add profile
      internal static let title = L10n.tr("Localizable", "ONBOARDING.AUTHENTICATION.TITLE", fallback: "Add profile")
    }
    internal enum Authorization {
      /// Confirm your fingerprint
      internal static let requestFingerprint = L10n.tr("Localizable", "ONBOARDING.AUTHORIZATION.REQUEST_FINGERPRINT", fallback: "Confirm your fingerprint")
    }
    internal enum CreatePin {
      /// NEXT
      internal static let confirm = L10n.tr("Localizable", "ONBOARDING.CREATE_PIN.CONFIRM", fallback: "NEXT")
      /// Choose a 4-digit PIN that can be used to authorise payments.
      internal static let description = L10n.tr("Localizable", "ONBOARDING.CREATE_PIN.DESCRIPTION", fallback: "Choose a 4-digit PIN that can be used to authorise payments.")
      /// Choose pin
      internal static let title = L10n.tr("Localizable", "ONBOARDING.CREATE_PIN.TITLE", fallback: "Choose pin")
    }
    internal enum EnterOneTimePassword {
      /// CONFIRM
      internal static let confirm = L10n.tr("Localizable", "ONBOARDING.ENTER_ONE_TIME_PASSWORD.CONFIRM", fallback: "CONFIRM")
      /// Please authorize the change with the confirmation code from your email inbox.
      internal static let description = L10n.tr("Localizable", "ONBOARDING.ENTER_ONE_TIME_PASSWORD.DESCRIPTION", fallback: "Please authorize the change with the confirmation code from your email inbox.")
      /// Enter confirmation code
      internal static let title = L10n.tr("Localizable", "ONBOARDING.ENTER_ONE_TIME_PASSWORD.TITLE", fallback: "Enter confirmation code")
    }
    internal enum FuelType {
      /// And finally: What fuel prices should we show you?
      internal static let description = L10n.tr("Localizable", "ONBOARDING.FUEL_TYPE.DESCRIPTION", fallback: "And finally: What fuel prices should we show you?")
      /// Fuel type
      internal static let title = L10n.tr("Localizable", "ONBOARDING.FUEL_TYPE.TITLE", fallback: "Fuel type")
    }
    internal enum PaymentMethod {
      /// Select a payment method to start your first refueling.
      internal static let description = L10n.tr("Localizable", "ONBOARDING.PAYMENT_METHOD.DESCRIPTION", fallback: "Select a payment method to start your first refueling.")
      /// Payment method
      internal static let title = L10n.tr("Localizable", "ONBOARDING.PAYMENT_METHOD.TITLE", fallback: "Payment method")
    }
    internal enum Permission {
      /// To show you the closest gas stations, we need to access your location.
      internal static let description = L10n.tr("Localizable", "ONBOARDING.PERMISSION.DESCRIPTION", fallback: "To show you the closest gas stations, we need to access your location.")
      /// Gas stations near you
      internal static let title = L10n.tr("Localizable", "ONBOARDING.PERMISSION.TITLE", fallback: "Gas stations near you")
    }
    internal enum Pin {
      internal enum Error {
        /// The PIN needs to be a 4-digit number.
        internal static let invalidLength = L10n.tr("Localizable", "ONBOARDING.PIN.ERROR.INVALID_LENGTH", fallback: "The PIN needs to be a 4-digit number.")
        /// The PINs don't match. Try again.
        internal static let mismatch = L10n.tr("Localizable", "ONBOARDING.PIN.ERROR.MISMATCH", fallback: "The PINs don't match. Try again.")
        /// The PIN is too simple (0000 or 1234 are not allowed). Choose a different PIN.
        internal static let notSecure = L10n.tr("Localizable", "ONBOARDING.PIN.ERROR.NOT_SECURE", fallback: "The PIN is too simple (0000 or 1234 are not allowed). Choose a different PIN.")
        /// The PIN can't be a series of ascending or descending numbers.
        internal static let series = L10n.tr("Localizable", "ONBOARDING.PIN.ERROR.SERIES", fallback: "The PIN can't be a series of ascending or descending numbers.")
        /// The PIN needs to contain at least three distinct digits.
        internal static let tooFewDigits = L10n.tr("Localizable", "ONBOARDING.PIN.ERROR.TOO_FEW_DIGITS", fallback: "The PIN needs to contain at least three distinct digits.")
      }
    }
    internal enum TwoFactorAuthentication {
      /// BIOMETRY
      internal static let biometry = L10n.tr("Localizable", "ONBOARDING.TWO_FACTOR_AUTHENTICATION.BIOMETRY", fallback: "BIOMETRY")
      /// Biometric scanners are the fastest and most secure way to confirm your payment transactions.
      internal static let description = L10n.tr("Localizable", "ONBOARDING.TWO_FACTOR_AUTHENTICATION.DESCRIPTION", fallback: "Biometric scanners are the fastest and most secure way to confirm your payment transactions.")
      /// Choose PIN
      internal static let pin = L10n.tr("Localizable", "ONBOARDING.TWO_FACTOR_AUTHENTICATION.PIN", fallback: "Choose PIN")
      /// Secure and fast payment
      internal static let title = L10n.tr("Localizable", "ONBOARDING.TWO_FACTOR_AUTHENTICATION.TITLE", fallback: "Secure and fast payment")
    }
    internal enum VerifyPin {
      /// NEXT
      internal static let confirm = L10n.tr("Localizable", "ONBOARDING.VERIFY_PIN.CONFIRM", fallback: "NEXT")
      /// Please re-enter the PIN for confirmation.
      internal static let description = L10n.tr("Localizable", "ONBOARDING.VERIFY_PIN.DESCRIPTION", fallback: "Please re-enter the PIN for confirmation.")
      /// Confirm pin
      internal static let title = L10n.tr("Localizable", "ONBOARDING.VERIFY_PIN.TITLE", fallback: "Confirm pin")
    }
  }
  internal enum Price {
    /// n. a.
    internal static let notAvailable = L10n.tr("Localizable", "PRICE.NOT_AVAILABLE", fallback: "n. a.")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
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
