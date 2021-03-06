// Copyright © 2021 PACE Telematics GmbH. All rights reserved.

import JamitFoundation
import UIKit

final class SeparatorHeaderFooterView: UITableViewHeaderFooterView {
    private lazy var lineView: UIView = .init()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        setupView()
    }

    private func setupView() {
        backgroundColor = Asset.Colors.Theme.background.color
        tintColor = Asset.Colors.Theme.background.color
        lineView.backgroundColor = Asset.Colors.Theme.backgroundGray.color
        lineView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(lineView)
        lineView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28).isActive = true
        lineView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -28).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        lineView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
