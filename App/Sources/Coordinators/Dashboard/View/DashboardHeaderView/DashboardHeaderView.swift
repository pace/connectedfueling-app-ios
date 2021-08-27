import JamitFoundation
import UIKit

final class DashboardHeaderView: StatefulView<DashboardHeaderViewModel> {
    @IBOutlet private var titleLabel: Label!

    var style: DashboardHeaderViewStyle = .default {
        didSet { didChangeStyle() }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        didChangeStyle()
    }

    override func didChangeModel() {
        super.didChangeModel()

        titleLabel.text = model.title
    }

    private func didChangeStyle() {
        titleLabel.style = style.titleStyle
    }
}
