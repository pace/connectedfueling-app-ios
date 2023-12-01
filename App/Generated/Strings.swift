// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// To show you the nearest gas station, we need access to your current location.
  internal static let alertLocationPermissionDescription = L10n.tr("Localizable", "alert_location_permission_description", fallback: "To show you the nearest gas station, we need access to your current location.")
  /// Location permission not granted
  internal static let alertLocationPermissionTitle = L10n.tr("Localizable", "alert_location_permission_title", fallback: "Location permission not granted")
  /// CLOSED
  internal static let closedLabel = L10n.tr("Localizable", "closed_label", fallback: "CLOSED")
  /// Start fueling
  internal static let commonStartFueling = L10n.tr("Localizable", "common_start_fueling", fallback: "Start fueling")
  /// Start navigation
  internal static let commonStartNavigation = L10n.tr("Localizable", "common_start_navigation", fallback: "Start navigation")
  /// Accept
  internal static let commonUseAccept = L10n.tr("Localizable", "common_use_accept", fallback: "Accept")
  /// Back
  internal static let commonUseBack = L10n.tr("Localizable", "common_use_back", fallback: "Back")
  /// Cancel
  internal static let commonUseCancel = L10n.tr("Localizable", "common_use_cancel", fallback: "Cancel")
  /// Confirm
  internal static let commonUseConfirm = L10n.tr("Localizable", "common_use_confirm", fallback: "Confirm")
  /// Decline
  internal static let commonUseDecline = L10n.tr("Localizable", "common_use_decline", fallback: "Decline")
  /// Friday
  internal static let commonUseFriday = L10n.tr("Localizable", "common_use_friday", fallback: "Friday")
  /// Monday
  internal static let commonUseMonday = L10n.tr("Localizable", "common_use_monday", fallback: "Monday")
  /// Connection to the Internet failed. Try again later.
  internal static let commonUseNetworkError = L10n.tr("Localizable", "common_use_network_error", fallback: "Connection to the Internet failed. Try again later.")
  /// Next
  internal static let commonUseNext = L10n.tr("Localizable", "common_use_next", fallback: "Next")
  /// Try again
  internal static let commonUseRetry = L10n.tr("Localizable", "common_use_retry", fallback: "Try again")
  /// Saturday
  internal static let commonUseSaturday = L10n.tr("Localizable", "common_use_saturday", fallback: "Saturday")
  /// Save
  internal static let commonUseSave = L10n.tr("Localizable", "common_use_save", fallback: "Save")
  /// Skip
  internal static let commonUseSkip = L10n.tr("Localizable", "common_use_skip", fallback: "Skip")
  /// Sunday
  internal static let commonUseSunday = L10n.tr("Localizable", "common_use_sunday", fallback: "Sunday")
  /// Thursday
  internal static let commonUseThursday = L10n.tr("Localizable", "common_use_thursday", fallback: "Thursday")
  /// Tuesday
  internal static let commonUseTuesday = L10n.tr("Localizable", "common_use_tuesday", fallback: "Tuesday")
  /// An unknown error has occurred. Try again later.
  internal static let commonUseUnknownError = L10n.tr("Localizable", "common_use_unknown_error", fallback: "An unknown error has occurred. Try again later.")
  /// Wednesday
  internal static let commonUseWednesday = L10n.tr("Localizable", "common_use_wednesday", fallback: "Wednesday")
  /// %2$@%1$@
  internal static func currencyFormat(_ p1: Any, _ p2: Any) -> String {
    return L10n.tr("Localizable", "currency_format", String(describing: p1), String(describing: p2), fallback: "%2$@%1$@")
  }
  /// Diesel
  internal static let fuelGroupDiesel = L10n.tr("Localizable", "fuel_group_diesel", fallback: "Diesel")
  /// Petrol
  internal static let fuelGroupPetrol = L10n.tr("Localizable", "fuel_group_petrol", fallback: "Petrol")
  /// What fuel prices should we show you?
  internal static let fuelTypeSelection = L10n.tr("Localizable", "FUEL_TYPE_SELECTION", fallback: "What fuel prices should we show you?")
  /// The gas station is currently closed.
  internal static let gasStationClosedHint = L10n.tr("Localizable", "gas_station_closed_hint", fallback: "The gas station is currently closed.")
  /// Gas station
  internal static let gasStationDefaultName = L10n.tr("Localizable", "gas_station_default_name", fallback: "Gas station")
  /// The gas station data could not be loaded. Check your connection!
  internal static let gasStationErrorDescription = L10n.tr("Localizable", "gas_station_error_description", fallback: "The gas station data could not be loaded. Check your connection!")
  /// Fuel prices are unfortunately not available.
  internal static let gasStationFuelPricesNotAvailable = L10n.tr("Localizable", "gas_station_fuel_prices_not_available", fallback: "Fuel prices are unfortunately not available.")
  /// Fuel prices
  internal static let gasStationFuelPricesTitle = L10n.tr("Localizable", "gas_station_fuel_prices_title", fallback: "Fuel prices")
  /// Last price change %s
  internal static func gasStationLastUpdated(_ p1: UnsafePointer<CChar>) -> String {
    return L10n.tr("Localizable", "gas_station_last_updated", p1, fallback: "Last price change %s")
  }
  /// We are loading the gas station data. Please wait a moment.
  internal static let gasStationLoadingDescription = L10n.tr("Localizable", "gas_station_loading_description", fallback: "We are loading the gas station data. Please wait a moment.")
  /// Loading gas station data...
  internal static let gasStationLoadingTitle = L10n.tr("Localizable", "gas_station_loading_title", fallback: "Loading gas station data...")
  /// %s away
  internal static func gasStationLocationAway(_ p1: UnsafePointer<CChar>) -> String {
    return L10n.tr("Localizable", "gas_station_location_away", p1, fallback: "%s away")
  }
  /// You are here
  internal static let gasStationLocationHere = L10n.tr("Localizable", "gas_station_location_here", fallback: "You are here")
  /// open 24 hours
  internal static let gasStationOpeningHoursAlwaysOpen = L10n.tr("Localizable", "gas_station_opening_hours_always_open", fallback: "open 24 hours")
  /// closed
  internal static let gasStationOpeningHoursClosed = L10n.tr("Localizable", "gas_station_opening_hours_closed", fallback: "closed")
  /// Daily
  internal static let gasStationOpeningHoursDaily = L10n.tr("Localizable", "gas_station_opening_hours_daily", fallback: "Daily")
  /// Opening hours may differ on holidays.
  internal static let gasStationOpeningHoursHint = L10n.tr("Localizable", "gas_station_opening_hours_hint", fallback: "Opening hours may differ on holidays.")
  /// Opening hours are currently not available.
  internal static let gasStationOpeningHoursNotAvailable = L10n.tr("Localizable", "gas_station_opening_hours_not_available", fallback: "Opening hours are currently not available.")
  /// Opening hours
  internal static let gasStationOpeningHoursTitle = L10n.tr("Localizable", "gas_station_opening_hours_title", fallback: "Opening hours")
  /// Loading failed
  internal static let generalErrorTitle = L10n.tr("Localizable", "general_error_title", fallback: "Loading failed")
  /// List
  internal static let listTabLabel = L10n.tr("Localizable", "list_tab_label", fallback: "List")
  /// More
  internal static let moreTabLabel = L10n.tr("Localizable", "more_tab_label", fallback: "More")
  /// Log in or register
  internal static let onboardingAuthenticationAction = L10n.tr("Localizable", "onboarding_authentication_action", fallback: "Log in or register")
  /// For easy payment with the app you have to register or login with your existing PACE-ID.
  internal static let onboardingAuthenticationDescription = L10n.tr("Localizable", "onboarding_authentication_description", fallback: "For easy payment with the app you have to register or login with your existing PACE-ID.")
  /// Add profile
  internal static let onboardingAuthenticationTitle = L10n.tr("Localizable", "onboarding_authentication_title", fallback: "Add profile")
  /// Choose a four-digit PIN to be used to confirm payments.
  internal static let onboardingCreatePinDescription = L10n.tr("Localizable", "onboarding_create_pin_description", fallback: "Choose a four-digit PIN to be used to confirm payments.")
  /// Choose PIN
  internal static let onboardingCreatePinTitle = L10n.tr("Localizable", "onboarding_create_pin_title", fallback: "Choose PIN")
  /// Please authorise the change with the confirmation code from your e-mail inbox.
  internal static let onboardingEnterOneTimePasswordDescription = L10n.tr("Localizable", "onboarding_enter_one_time_password_description", fallback: "Please authorise the change with the confirmation code from your e-mail inbox.")
  /// Enter confirmation code
  internal static let onboardingEnterOneTimePasswordTitle = L10n.tr("Localizable", "onboarding_enter_one_time_password_title", fallback: "Enter confirmation code")
  /// Your input could not be verified. Please try again.
  internal static let onboardingErrorAuthorization = L10n.tr("Localizable", "onboarding_error_authorization", fallback: "Your input could not be verified. Please try again.")
  /// And finally: Which fuel prices should we show you?
  internal static let onboardingFuelTypeDescription = L10n.tr("Localizable", "onboarding_fuel_type_description", fallback: "And finally: Which fuel prices should we show you?")
  /// Fuel type
  internal static let onboardingFuelTypeTitle = L10n.tr("Localizable", "onboarding_fuel_type_title", fallback: "Fuel type")
  /// Please select a fuel type.
  internal static let onboardingFuelTypeUnselectedText = L10n.tr("Localizable", "onboarding_fuel_type_unselected_text", fallback: "Please select a fuel type.")
  /// Your session has expired.
  internal static let onboardingInvalidSession = L10n.tr("Localizable", "onboarding_invalid_session", fallback: "Your session has expired.")
  /// privacy policy
  internal static let onboardingLegalDataPrivacy = L10n.tr("Localizable", "onboarding_legal_data_privacy", fallback: "privacy policy")
  /// I agree to the terms of use and have read and understood the privacy policy.
  internal static let onboardingLegalDescription = L10n.tr("Localizable", "onboarding_legal_description", fallback: "I agree to the terms of use and have read and understood the privacy policy.")
  /// terms of use
  internal static let onboardingLegalTermsOfUse = L10n.tr("Localizable", "onboarding_legal_terms_of_use", fallback: "terms of use")
  /// Before we continue
  internal static let onboardingLegalTitle = L10n.tr("Localizable", "onboarding_legal_title", fallback: "Before we continue")
  /// Login failed. Without an account, paying your fuel with your smartphone is not possible.
  internal static let onboardingLoginUnsuccessful = L10n.tr("Localizable", "onboarding_login_unsuccessful", fallback: "Login failed. Without an account, paying your fuel with your smartphone is not possible.")
  /// Add payment method
  internal static let onboardingPaymentMethodAction = L10n.tr("Localizable", "onboarding_payment_method_action", fallback: "Add payment method")
  /// Select a payment method to start your first refueling.
  internal static let onboardingPaymentMethodDescription = L10n.tr("Localizable", "onboarding_payment_method_description", fallback: "Select a payment method to start your first refueling.")
  /// Payment method
  internal static let onboardingPaymentMethodTitle = L10n.tr("Localizable", "onboarding_payment_method_title", fallback: "Payment method")
  /// Allow location access
  internal static let onboardingPermissionAction = L10n.tr("Localizable", "onboarding_permission_action", fallback: "Allow location access")
  /// To show you the closest gas station, we need access to your precise location.
  internal static let onboardingPermissionDescription = L10n.tr("Localizable", "onboarding_permission_description", fallback: "To show you the closest gas station, we need access to your precise location.")
  /// Gas stations near you
  internal static let onboardingPermissionTitle = L10n.tr("Localizable", "onboarding_permission_title", fallback: "Gas stations near you")
  /// The PIN must be a 4-digit number.
  internal static let onboardingPinErrorInvalidLength = L10n.tr("Localizable", "onboarding_pin_error_invalid_length", fallback: "The PIN must be a 4-digit number.")
  /// The PINs do not match. Try again.
  internal static let onboardingPinErrorMismatch = L10n.tr("Localizable", "onboarding_pin_error_mismatch", fallback: "The PINs do not match. Try again.")
  /// The PIN is too simple (0000 or 1234 are not allowed). Choose a different PIN
  internal static let onboardingPinErrorNotSecure = L10n.tr("Localizable", "onboarding_pin_error_not_secure", fallback: "The PIN is too simple (0000 or 1234 are not allowed). Choose a different PIN")
  /// The PIN must not be a series of ascending or descending digits.
  internal static let onboardingPinErrorSeries = L10n.tr("Localizable", "onboarding_pin_error_series", fallback: "The PIN must not be a series of ascending or descending digits.")
  /// The PIN must contain at least three different digits.
  internal static let onboardingPinErrorTooFewDigits = L10n.tr("Localizable", "onboarding_pin_error_too_few_digits", fallback: "The PIN must contain at least three different digits.")
  /// Retry login
  internal static let onboardingRetryLogin = L10n.tr("Localizable", "onboarding_retry_login", fallback: "Retry login")
  /// app tracking
  internal static let onboardingTrackingAppTracking = L10n.tr("Localizable", "onboarding_tracking_app_tracking", fallback: "app tracking")
  /// Allow app tracking so that we can further optimise the use of the app for you.
  internal static let onboardingTrackingDescription = L10n.tr("Localizable", "onboarding_tracking_description", fallback: "Allow app tracking so that we can further optimise the use of the app for you.")
  /// Improve your experience
  internal static let onboardingTrackingTitle = L10n.tr("Localizable", "onboarding_tracking_title", fallback: "Improve your experience")
  /// Biometry
  internal static let onboardingTwoFactorAuthenticationBiometry = L10n.tr("Localizable", "onboarding_two_factor_authentication_biometry", fallback: "Biometry")
  /// Biometric scanners are the fastest and most secure way to confirm your payment transactions.
  internal static let onboardingTwoFactorAuthenticationDescription = L10n.tr("Localizable", "onboarding_two_factor_authentication_description", fallback: "Biometric scanners are the fastest and most secure way to confirm your payment transactions.")
  /// Choose PIN
  internal static let onboardingTwoFactorAuthenticationPin = L10n.tr("Localizable", "onboarding_two_factor_authentication_pin", fallback: "Choose PIN")
  /// Secure and fast payment
  internal static let onboardingTwoFactorAuthenticationTitle = L10n.tr("Localizable", "onboarding_two_factor_authentication_title", fallback: "Secure and fast payment")
  /// Please enter the PIN again to confirm.
  internal static let onboardingVerifyPinDescription = L10n.tr("Localizable", "onboarding_verify_pin_description", fallback: "Please enter the PIN again to confirm.")
  /// Confirm PIN
  internal static let onboardingVerifyPinTitle = L10n.tr("Localizable", "onboarding_verify_pin_title", fallback: "Confirm PIN")
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
  /// Share
  internal static let shareTitle = L10n.tr("Localizable", "SHARE_TITLE", fallback: "Share")
  /// Delete account
  internal static let walletAccountDeletionTitle = L10n.tr("Localizable", "wallet_account_deletion_title", fallback: "Delete account")
  /// Fuel selection
  internal static let walletFuelTypeSelectionTitle = L10n.tr("Localizable", "wallet_fuel_type_selection_title", fallback: "Fuel selection")
  /// You are logged in as
  internal static let walletHeaderText = L10n.tr("Localizable", "wallet_header_text", fallback: "You are logged in as")
  /// Payment methods & fuel cards
  internal static let walletPaymentMethodsTitle = L10n.tr("Localizable", "wallet_payment_methods_title", fallback: "Payment methods & fuel cards")
  /// Wallet
  internal static let walletTabLabel = L10n.tr("Localizable", "wallet_tab_label", fallback: "Wallet")
  /// Transactions
  internal static let walletTransactionsTitle = L10n.tr("Localizable", "wallet_transactions_title", fallback: "Transactions")
  /// Authorisation
  internal static let walletTwoFactorAuthenticationTitle = L10n.tr("Localizable", "wallet_two_factor_authentication_title", fallback: "Authorisation")
  internal enum Alert {
    internal enum LocationPermission {
      internal enum Actions {
        /// Open settings
        internal static let openSettings = L10n.tr("Localizable", "ALERT.LOCATION_PERMISSION.ACTIONS.OPEN_SETTINGS", fallback: "Open settings")
      }
    }
  }
  internal enum Dashboard {
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
