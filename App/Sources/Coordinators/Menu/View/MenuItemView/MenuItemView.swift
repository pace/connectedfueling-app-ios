import JamitFoundation
import UIKit

final class MenuItemView: CofuView<MenuItemViewModel> {
    private lazy var titleLabel: Label = {
        let label: Label = .instantiate()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var iconImageView: UIImageView = {
        let imageView: UIImageView = .instantiate()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    var style: MenuItemViewStyle = .default {
        didSet { didChangeStyle() }
    }

    override func didChangeModel() {
        super.didChangeModel()

        titleLabel.text = model.title
        iconImageView.image = model.icon
    }

    override func setup() {
        [
            titleLabel,
            iconImageView
        ].forEach(addSubview)

        iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        iconImageView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true

        titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 32).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(greaterThanOrEqualTo: bottomAnchor, constant: 20).isActive = true
        titleLabel.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 20).isActive = true
    }

    private func didChangeStyle() {
        titleLabel.style = style.titleStyle
    }
}
