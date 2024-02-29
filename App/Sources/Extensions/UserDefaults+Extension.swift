import Foundation

extension UserDefaults {
    enum Key {
        static let isOnboardingCompleted: String = "isOnboardingCompleted"

        fileprivate static let firstStart: String = "firstStart"
        fileprivate static let migrationVersion: String = "migrationVersion"
        fileprivate static let fuelType: String = "fuelType"
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
}

extension UserDefaults {
    @objc var fuelTypeRawValue: String {
        get { UserDefaults.standard.string(forKey: Key.fuelType) ?? Constants.FuelTypeFilter.defaultFuelType.rawValue }
        set { UserDefaults.standard.set(newValue, forKey: Key.fuelType) }
    }
}
