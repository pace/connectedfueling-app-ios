import Foundation

/// EnvironmentConfiguration represents the Configuration files which can be found under
/// SupportingFiles/Configurations/*.xcconfig
internal struct EnvironmentConfiguration: Decodable {
    let appName: String
}

// MARK: - EnvironmentConfiguration CodingKeys
extension EnvironmentConfiguration {
    enum CodingKeys: String, CodingKey {
        case appName = "APP_NAME"
    }
}
