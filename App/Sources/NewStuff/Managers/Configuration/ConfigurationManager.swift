import Foundation

enum ConfigurationManager {
    static let configuration: Configuration = loadConfiguration()

    private static func loadConfiguration() -> Configuration {
        guard let configPath = Bundle.main.path(forResource: "configuration", ofType: "json") else {
            fatalError("[ConfigurationManager] Could not find configuration.json")
        }

        do {
            let configData = try Data(contentsOf: URL(fileURLWithPath: configPath))
            let config = try JSONDecoder().decode(Configuration.self, from: configData)

            NSLog("[ConfigurationManager] Successfully loaded configuration")

            return config
        } catch {
            fatalError("[ConfigurationManager] Failed loading configuration with error \(error)")
        }
    }
}
