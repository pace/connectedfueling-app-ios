import JamitFoundation
import UIKit

final class OnboardingViewController: CofuViewController<OnboardingViewModel> {
    private enum Constants {
        static let screenHeightThreshold: CGFloat = 736
    }

    private lazy var imageView: UIImageView = {
        let imageView: UIImageView = .instantiate()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var titleLabel: Label = {
        let label: Label = .instantiate()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var descriptionLabel: Label = {
        let label: Label = .instantiate()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView: UIActivityIndicatorView = .instantiate()
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicatorView
    }()

    private lazy var radioButtonStackView: UIStackView = {
        let stackView: UIStackView = .init(arrangedSubviews: [])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        return stackView
    }()

    private lazy var actionButton: ButtonView = {
        let button: ButtonView = .instantiate()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var secondaryActionButton: ButtonView = {
        let button: ButtonView = .instantiate()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    var imageViewTopConstraint: NSLayoutConstraint?
    var titleTopConstraint: NSLayoutConstraint?
    var descriptionTopConstraint: NSLayoutConstraint?
    var descriptionLeadingConstraint: NSLayoutConstraint?
    var descriptionTrailingConstraint: NSLayoutConstraint?
    var descriptionBottomConstraint: NSLayoutConstraint?

    var style: OnboardingViewStyle = UIScreen.main.bounds.height > Constants.screenHeightThreshold ? .default : .compact {
        didSet { didChangeStyle() }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        didChangeStyle()
    }

    override func didChangeModel() {
        super.didChangeModel()

        imageView.image = model.image
        titleLabel.text = model.title
        descriptionLabel.text = model.description
        secondaryActionButton.isHidden = model.secondaryAction == nil
        model.secondaryAction.flatMap { secondaryActionButton.model = $0 }
        actionButton.model = model.action

        if model.isLoading {
            activityIndicatorView.startAnimating()
        } else {
            activityIndicatorView.stopAnimating()
        }

        titleTopConstraint?.constant = model.applyLargeTitleInset ? style.iconSpacingBottom : style.iconSpacingBottom * 0.5

        updateRadioButtons()
    }

    private func updateRadioButtons() {
        let buttons = radioButtonStackView.arrangedSubviews.compactMap { $0 as? ButtonView }
        radioButtonStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        zip(buttons, model.radios).forEach { view, model in
            view.model = model
            view.style = .radio
            view.isHidden = false
            radioButtonStackView.addArrangedSubview(view)
        }

        if buttons.count < model.radios.count {
            model.radios[buttons.count ..< model.radios.count].forEach { model in
                let view = ButtonView.instantiate()
                view.model = model
                view.style = .radio
                radioButtonStackView.addArrangedSubview(view)
            }
        }
    }

    override func setup() {
        super.setup()

        [
            imageView,
            titleLabel,
            descriptionLabel,
            activityIndicatorView,
            radioButtonStackView,
            actionButton,
            secondaryActionButton
        ].forEach(view.addSubview)

        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        imageViewTopConstraint = imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100)
        imageViewTopConstraint?.isActive = true

        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        titleTopConstraint = titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -40)
        titleTopConstraint?.isActive = true

        descriptionTopConstraint = descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: -14)
        descriptionBottomConstraint = descriptionLabel.bottomAnchor.constraint(equalTo: activityIndicatorView.topAnchor, constant: 40)
        descriptionLeadingConstraint = descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60)
        descriptionTrailingConstraint = descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60)

        [descriptionTopConstraint, descriptionLeadingConstraint, descriptionTrailingConstraint, descriptionBottomConstraint].forEach { $0?.isActive = true }

        activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        secondaryActionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60).isActive = true
        secondaryActionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60).isActive = true
        secondaryActionButton.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -10).isActive = true

        actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35).isActive = true
        actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35).isActive = true
        actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40).isActive = true

        radioButtonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35).isActive = true
        radioButtonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35).isActive = true
        radioButtonStackView.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -30).isActive = true
    }

    private func didChangeStyle() {
        titleLabel.style = style.titleStyle
        descriptionLabel.style = style.descriptionStyle
        secondaryActionButton.style = style.secondaryAction
        actionButton.style = style.primaryAction
        radioButtonStackView.arrangedSubviews
            .compactMap { $0 as? ButtonView }
            .forEach { $0.style = style.radio }

        view.backgroundColor = style.backgroundColor
        imageViewTopConstraint?.constant = style.iconSpacingTop

        titleTopConstraint?.constant = model.applyLargeTitleInset ? style.iconSpacingBottom : style.iconSpacingBottom * 0.5
        descriptionTopConstraint?.constant = style.descriptionInsets.top
        descriptionLeadingConstraint?.constant = style.descriptionInsets.left
        descriptionTrailingConstraint?.constant = -style.descriptionInsets.right
        descriptionBottomConstraint?.constant = -style.descriptionInsets.bottom
    }
}
