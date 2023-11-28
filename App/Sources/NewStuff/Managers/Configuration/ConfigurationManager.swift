import Foundation

enum ConfigurationManager {
    static let configuration: Configuration = loadConfiguration()

    private static func loadConfiguration() -> Configuration {
        SystemManager.loadJSONFromBundle(fileName: Constants.File.configuration)
    }
}
