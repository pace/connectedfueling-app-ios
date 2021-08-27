import JamitFoundation
import UIKit

final class OnboardingViewController: StatefulViewController<OnboardingViewModel> {
    private enum Constants {
        static let screenHeightThreshold: CGFloat = 736
    }

    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var titleLabel: Label!
    @IBOutlet private var descriptionLabel: Label!
    @IBOutlet private var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet private var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet private var imageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet private var titleTopConstraint: NSLayoutConstraint!
    @IBOutlet private var descriptionTopConstraint: NSLayoutConstraint!
    @IBOutlet private var descriptionLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private var descriptionTrailingConstraint: NSLayoutConstraint!
    @IBOutlet private var descriptionBottomConstraint: NSLayoutConstraint!

    private lazy var actionStackView: UIStackView = .init(arrangedSubviews: [])
    private lazy var secondaryActionButton: ButtonView = .instantiate()

    private lazy var secondaryActionBoundBottomAnchor: NSLayoutConstraint = actionStackView.bottomAnchor.constraint(
        equalTo: secondaryActionButton.topAnchor,
        constant: -10
    )

    private lazy var parentBoundBottomAnchor: NSLayoutConstraint = actionStackView.bottomAnchor.constraint(
        equalTo: view.bottomAnchor,
        constant: -60
    )

    var style: OnboardingViewStyle = UIScreen.main.bounds.height > Constants.screenHeightThreshold ? .default : .compact {
        didSet { didChangeStyle() }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        secondaryActionButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(secondaryActionButton)
        secondaryActionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60).isActive = true
        secondaryActionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60).isActive = true
        secondaryActionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60).isActive = true

        actionStackView.alignment = .fill
        actionStackView.axis = .vertical
        actionStackView.spacing = 10
        actionStackView.distribution = .fillEqually
        actionStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(actionStackView)
        actionStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35).isActive = true
        actionStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35).isActive = true
        secondaryActionBoundBottomAnchor.isActive = true
        parentBoundBottomAnchor.isActive = false

        didChangeStyle()
    }

    override func didChangeModel() {
        super.didChangeModel()

        imageView.image = model.image
        titleLabel.text = model.title
        descriptionLabel.text = model.description
        secondaryActionButton.isHidden = model.secondaryAction == nil
        model.secondaryAction.flatMap { secondaryActionButton.model = $0 }

        if model.isLoading {
            activityIndicatorView.startAnimating()
        } else {
            activityIndicatorView.stopAnimating()
        }

        if model.applySecondaryActionInset {
            parentBoundBottomAnchor.isActive = false
            secondaryActionBoundBottomAnchor.isActive = true
        } else {
            secondaryActionBoundBottomAnchor.isActive = false
            parentBoundBottomAnchor.isActive = true
        }

        titleTopConstraint.constant = model.applyLargeTitleInset ? style.iconSpacingBottom : style.iconSpacingBottom * 0.5

        updateActionButtons()
    }

    private func updateActionButtons() {
        let buttons = actionStackView.arrangedSubviews.compactMap { $0 as? ButtonView }
        actionStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        zip(buttons, model.actions).forEach { view, model in
            view.model = model
            view.isHidden = false
            actionStackView.addArrangedSubview(view)
        }

        if buttons.count < model.actions.count {
            model.actions[buttons.count ..< model.actions.count].forEach { model in
                let view = ButtonView.instantiate()
                view.model = model
                actionStackView.addArrangedSubview(view)
            }
        }
    }

    private func didChangeStyle() {
        titleLabel.style = style.titleStyle
        descriptionLabel.style = style.descriptionStyle
        secondaryActionButton.style = style.secondaryAction
        actionStackView.arrangedSubviews
            .compactMap { $0 as? ButtonView }
            .forEach { $0.style = style.primaryAction }

        view.backgroundColor = style.backgroundColor
        imageViewTopConstraint.constant = style.iconSpacingTop

        if imageViewWidthConstraint.multiplier != style.iconWidth {
            imageViewWidthConstraint.isActive = false
            imageViewWidthConstraint = imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: style.iconWidth)
            imageViewWidthConstraint.isActive = true
        }

        titleTopConstraint.constant = model.applyLargeTitleInset ? style.iconSpacingBottom : style.iconSpacingBottom * 0.5
        descriptionTopConstraint.constant = style.descriptionInsets.top
        descriptionLeadingConstraint.constant = style.descriptionInsets.left
        descriptionTrailingConstraint.constant = style.descriptionInsets.right
        descriptionBottomConstraint.constant = style.descriptionInsets.bottom
    }
}
