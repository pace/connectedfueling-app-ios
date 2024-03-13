import CryptoKit
import Foundation

extension Insecure.MD5.Digest {
    /// The base64-encoded format of the MD5 Hash
    var hashString: String {
        return Data(self).base64EncodedString()
    }
}
