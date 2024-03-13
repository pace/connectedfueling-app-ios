import Foundation

extension UserDefaults {
    enum Key {
        static let termsAcceptedHash: String = "termsAcceptedHash"
        static let termsAcceptedLocale: String = "termsAcceptedLocale"
        static let dataPrivacyAcceptedHash: String = "dataPrivacyAcceptedHash"
        static let dataPrivacyAcceptedLocale: String = "dataPrivacyAcceptedLocale"
        static let trackingAcceptedHash: String = "trackingAcceptedHash"
        static let trackingAcceptedLocale: String = "trackingAcceptedLocale"
        static let isOnboardingCompleted: String = "isOnboardingCompleted"

        fileprivate static let firstStart: String = "firstStart"
        fileprivate static let migrationVersion: String = "migrationVersion"
        fileprivate static let fuelType: String = "fuelType"
        fileprivate static let didAskForAnalytics: String = "didAskForAnalytics"
        fileprivate static let isAnalyticsAllowed: String = "isAnalyticsAllowed"
        fileprivate static let is2FANeededForPayments: String = "is2FANeededForPayments"
        fileprivate static let isNativePaymentMethodOnboardingEnabled: String = "isNativePaymentMethodOnboardingEnabled"
    }
}

extension UserDefaults {

    class var firstStart: Bool {
        get { UserDefaults.standard.bool(forKey: Key.firstStart) }
        set { UserDefaults.standard.set(newValue, forKey: Key.firstStart) }
    }

    class var migrationVersion: Int {
        get { UserDefaults.standard.integer(forKey: Key.migrationVersion) }
        set { UserDefaults.standard.set(newValue, forKey: Key.migrationVersion) }
    }

    class var isOnboardingCompleted: Bool {
        get { UserDefaults.standard.bool(forKey: Key.isOnboardingCompleted) }
        set { UserDefaults.standard.set(newValue, forKey: Key.isOnboardingCompleted) }
    }

    class var fuelType: FuelType {
        get { FuelType(rawValue: UserDefaults.standard.fuelTypeRawValue) ?? Constants.FuelTypeFilter.defaultFuelType }
        set { UserDefaults.standard.fuelTypeRawValue = newValue.rawValue }
    }

    class var didAskForAnalytics: Bool {
        get { UserDefaults.standard.bool(forKey: Key.didAskForAnalytics) }
        set { UserDefaults.standard.set(newValue, forKey: Key.didAskForAnalytics) }
    }

    class var isAnalyticsAllowed: Bool {
        get { UserDefaults.standard.bool(forKey: Key.isAnalyticsAllowed) }
        set { UserDefaults.standard.set(newValue, forKey: Key.isAnalyticsAllowed) }
    }

    class var is2FANeededForPayments: Bool {
        get { UserDefaults.standard.bool(forKey: Key.is2FANeededForPayments) }
        set { UserDefaults.standard.set(newValue, forKey: Key.is2FANeededForPayments) }
    }
    
    class var isNativePaymentMethodOnboardingEnabled: Bool {
        get { UserDefaults.standard.bool(forKey: Key.isNativePaymentMethodOnboardingEnabled) }
        set { UserDefaults.standard.set(newValue, forKey: Key.isNativePaymentMethodOnboardingEnabled) }
    }

    class var termsAcceptedHash: String? {
        get { UserDefaults.standard.string(forKey: Key.termsAcceptedHash) }
        set { UserDefaults.standard.setValue(newValue, forKey: Key.termsAcceptedHash) }
    }

    class var termsAcceptedLocale: String? {
        get { UserDefaults.standard.string(forKey: Key.termsAcceptedLocale) }
        set { UserDefaults.standard.setValue(newValue, forKey: Key.termsAcceptedLocale) }
    }

    class var dataPrivacyAcceptedHash: String? {
        get { UserDefaults.standard.string(forKey: Key.dataPrivacyAcceptedHash) }
        set { UserDefaults.standard.setValue(newValue, forKey: Key.dataPrivacyAcceptedHash) }
    }

    class var dataPrivacyAcceptedLocale: String? {
        get { UserDefaults.standard.string(forKey: Key.dataPrivacyAcceptedLocale) }
        set { UserDefaults.standard.setValue(newValue, forKey: Key.dataPrivacyAcceptedLocale) }
    }

    class var trackingAcceptedHash: String? {
        get { UserDefaults.standard.string(forKey: Key.trackingAcceptedHash) }
        set { UserDefaults.standard.setValue(newValue, forKey: Key.trackingAcceptedHash) }
    }

    class var trackingAcceptedLocale: String? {
        get { UserDefaults.standard.string(forKey: Key.trackingAcceptedLocale) }
        set { UserDefaults.standard.setValue(newValue, forKey: Key.trackingAcceptedLocale) }
    }
}

extension UserDefaults {
    @objc var fuelTypeRawValue: String {
        get { UserDefaults.standard.string(forKey: Key.fuelType) ?? Constants.FuelTypeFilter.defaultFuelType.rawValue }
        set { UserDefaults.standard.set(newValue, forKey: Key.fuelType) }
    }
}
