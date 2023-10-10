import JamitFoundation
import UIKit

final class OnboardingViewController: StatefulViewController<OnboardingViewModelOld> {
    private enum Constants {
        static let screenHeightThreshold: CGFloat = 736
    }

    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var titleLabel: Label!
    @IBOutlet private var descriptionLabel: Label!
    @IBOutlet private var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet private var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet private var titleTopConstraint: NSLayoutConstraint!
    @IBOutlet private var descriptionTopConstraint: NSLayoutConstraint!
    @IBOutlet private var descriptionLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private var descriptionTrailingConstraint: NSLayoutConstraint!
    @IBOutlet private var descriptionBottomConstraint: NSLayoutConstraint!

    private lazy var radioButtonStackView: UIStackView = .init(arrangedSubviews: [])
    private lazy var actionButton: ButtonView = .instantiate()
    private lazy var secondaryActionButton: ButtonView = .instantiate()

    var style: OnboardingViewStyle = UIScreen.main.bounds.height > Constants.screenHeightThreshold ? .default : .compact {
        didSet { didChangeStyle() }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(secondaryActionButton)
        view.addSubview(actionButton)
        view.addSubview(radioButtonStackView)

        secondaryActionButton.translatesAutoresizingMaskIntoConstraints = false
        secondaryActionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60).isActive = true
        secondaryActionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60).isActive = true
        secondaryActionButton.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -10).isActive = true

        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35).isActive = true
        actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35).isActive = true
        actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40).isActive = true

        radioButtonStackView.alignment = .fill
        radioButtonStackView.axis = .vertical
        radioButtonStackView.spacing = 10
        radioButtonStackView.distribution = .fillEqually
        radioButtonStackView.translatesAutoresizingMaskIntoConstraints = false
        radioButtonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35).isActive = true
        radioButtonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35).isActive = true
        radioButtonStackView.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -30).isActive = true

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

        titleTopConstraint.constant = model.applyLargeTitleInset ? style.iconSpacingBottom : style.iconSpacingBottom * 0.5

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

    private func didChangeStyle() {
        titleLabel.style = style.titleStyle
        descriptionLabel.style = style.descriptionStyle
        secondaryActionButton.style = style.secondaryAction
        actionButton.style = style.primaryAction
        radioButtonStackView.arrangedSubviews
            .compactMap { $0 as? ButtonView }
            .forEach { $0.style = style.radio }

        view.backgroundColor = style.backgroundColor
        imageViewTopConstraint.constant = style.iconSpacingTop

        titleTopConstraint.constant = model.applyLargeTitleInset ? style.iconSpacingBottom : style.iconSpacingBottom * 0.5
        descriptionTopConstraint.constant = style.descriptionInsets.top
        descriptionLeadingConstraint.constant = style.descriptionInsets.left
        descriptionTrailingConstraint.constant = style.descriptionInsets.right
        descriptionBottomConstraint.constant = style.descriptionInsets.bottom
    }
}
