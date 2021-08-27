import JamitFoundation
import UIKit

final class MenuItemView: StatefulView<MenuItemViewModel> {
    @IBOutlet private var titleLabel: Label!
    @IBOutlet private var iconImageView: UIImageView!

    var style: MenuItemViewStyle = .default {
        didSet { didChangeStyle() }
    }

    override func didChangeModel() {
        super.didChangeModel()

        titleLabel.text = model.title
        iconImageView.image = model.icon
    }

    private func didChangeStyle() {
        titleLabel.style = style.titleStyle
    }
}
