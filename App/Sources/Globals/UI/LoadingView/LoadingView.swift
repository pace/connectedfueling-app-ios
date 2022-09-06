import JamitFoundation
import UIKit

final class LoadingView: CofuView<LoadingViewModel> {
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator: UIActivityIndicatorView = .instantiate()
        if #available(iOS 13.0, *) {
            activityIndicator.style = .large
        } else {
            activityIndicator.style = .gray
        }
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()

    private lazy var imageView: UIImageView = {
        let imageView: UIImageView = .instantiate()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var titleLabel: Label = {
        let label: Label = .instantiate()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var descriptionLabel: Label = {
        let label: Label = .instantiate()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func setup() {
        super.setup()

        [
            activityIndicator,
            imageView,
            titleLabel,
            descriptionLabel
        ].forEach(addSubview)

        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -75).isActive = true

        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.33).isActive = true
        imageView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -70).isActive = true
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 136 / 137).isActive = true

        titleLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 25).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -25).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -14).isActive = true

        descriptionLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 25).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -25).isActive = true
    }

    override func didChangeModel() {
        super.didChangeModel()

        imageView.image = model.image
        titleLabel.text = model.title
        descriptionLabel.text = model.description
    }
}
