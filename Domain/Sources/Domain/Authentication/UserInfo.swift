import Foundation

public struct UserInfo {
    public var email: String?
    public var firstName: String?
    public var lastName: String?
    public var isEmailVerified: Bool?

    public init(
        firstName: String?,
        lastName: String?,
        email: String?,
        isEmailVerified: Bool?
    ) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.isEmailVerified = isEmailVerified
    }
}
