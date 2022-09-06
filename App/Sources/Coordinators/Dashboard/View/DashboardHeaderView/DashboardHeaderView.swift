import JamitFoundation
import UIKit

final class DashboardHeaderView: CofuView<DashboardHeaderViewModel> {
    private lazy var titleLabel: Label = {
        let label: Label = .instantiate()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

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

    override func setup() {
        addSubview(titleLabel)

        titleLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 25).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -25).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 30).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
    }

    private func didChangeStyle() {
        titleLabel.style = style.titleStyle
    }
}
