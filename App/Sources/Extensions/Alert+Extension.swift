import SwiftUI

extension Alert: @retroactive Identifiable {
    public var id: String {
        String(describing: self)
    }
}
