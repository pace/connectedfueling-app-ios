import Foundation
import PACECloudSDK

/// Instance of the global configured environment
let environment: Environment = .init(infoPropertyListName: "Info")

/// Instance of the global environment of the PACECloudSDK
let sdkEnvironment: PACECloudSDK.Environment = {
    #if PRODUCTION
        return .production
    #elseif STAGING
        return .stage
    #else
        return .sandbox
    #endif
}()

/// Represents the configuration properties which are used app wide for example BaseURL etc.
/// The Environment is the mapped Info.plist file and its containing configuration entry
struct Environment: Decodable {
    private let configuration: EnvironmentConfiguration

    fileprivate init(infoPropertyListName filename: String) {
        guard
            let path = Bundle.main.path(forResource: filename, ofType: "plist"),
            let file = FileManager.default.contents(atPath: path)
        else {
            fatalError("Environment initialization is missing Info.plist file!")
        }

        do {
            let decoder = PropertyListDecoder()
            self = try decoder.decode(Environment.self, from: file)
        } catch {
            fatalError("Could not decode Info.plist environments - \(error.localizedDescription)")
        }
    }
}

// MARK: - Properties
extension Environment {
    var appName: String {
        return configuration.appName
    }
}

// MARK: - CodingKeys
extension Environment {
    enum CodingKeys: String, CodingKey {
        case configuration = "Configuration"
    }
}
