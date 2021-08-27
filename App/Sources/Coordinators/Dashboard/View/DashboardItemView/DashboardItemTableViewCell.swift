import JamitFoundation
import UIKit

final class DashboardItemTableViewCell: ContainerTableViewCell<DashboardItemView> {
    override func viewDidLoad() {
        super.viewDidLoad()

        backgroundColor = .clear
        contentInsets = .init(top: 7.5, left: 25, bottom: 7.5, right: -25)
    }
}
