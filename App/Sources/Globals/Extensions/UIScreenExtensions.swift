import UIKit

extension UIScreen {
    var isCompactSize: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone && bounds.height <= 568
    }
}
