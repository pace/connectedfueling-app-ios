import Foundation

// swiftlint:disable type_name
extension String: Identifiable {
    public typealias ID = Int

    public var id: Int {
        return hash
    }
}
