import Foundation

enum MigrationManager {
    private static let migrationVersion: Int = 1

    static func migrate() {
        let previousMigrationVersion = UserDefaults.standard.integer(forKey: Constants.UserDefaults.migrationVersion)

        guard previousMigrationVersion < migrationVersion else { return }

        if previousMigrationVersion < 1 {
            migrateIsOnboardingCompleted()
            migrateFuelType()
        }

        UserDefaults.standard.set(migrationVersion, forKey: Constants.UserDefaults.migrationVersion)
    }
}

private extension MigrationManager {
    static func migrateIsOnboardingCompleted() {
        let oldKey = "car.pace.ConnectedFueling.isOnboardingCompleted"
        
        guard let oldData = UserDefaults.standard.object(forKey: oldKey) as? Data,
              let oldValue = try? JSONDecoder().decode(Bool.self, from: oldData) else { return }

        UserDefaults.standard.set(oldValue, forKey: Constants.UserDefaults.isOnboardingCompleted)
        UserDefaults.standard.set(nil, forKey: oldKey)
    }

    static func migrateFuelType() {
        guard UserDefaults.standard.bool(forKey: Constants.UserDefaults.isOnboardingCompleted) else { return }

        let oldKey = "car.pace.ConnectedFueling.fuelType"
        var poiManager: POIManager = .init()

        if let oldData = UserDefaults.standard.object(forKey: oldKey) as? Data,
           let oldValue = try? JSONDecoder().decode(FuelType.self, from: oldData) {

            if oldValue == .diesel {
                poiManager.fuelType = .cheapestDiesel
            } else {
                poiManager.fuelType = Constants.FuelTypeFilter.defaultFuelType
            }

            UserDefaults.standard.set(nil, forKey: oldKey)
        } else {

            // Onboarding has already been completed but there is no old data
            // Set default fuel type
            poiManager.fuelType = Constants.FuelTypeFilter.defaultFuelType
        }
    }
}