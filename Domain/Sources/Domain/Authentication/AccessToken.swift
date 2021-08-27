import Foundation

public struct AccessToken: RawRepresentable, Hashable, Equatable, Codable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}
