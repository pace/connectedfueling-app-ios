import JamitFoundation
import UIKit

final class DashboardItemView: CofuView<DashboardItemViewModel> {
    enum Constants {
        static let distanceFormattingThresholdForMetersPrecision: Double = 1.0
        static let distanceFormattingThresholdInKm: Double = 10.0
        static let roundingThreshold: Double = 0.05
    }

    private lazy var distanceImageView: UIImageView = {
        let imageView: UIImageView = .instantiate()
        imageView.image = Asset.Images.navigation.image
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
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var priceLabel: Label = {
        let label: Label = .instantiate()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var fuelTypeLabel: Label = {
        let label: Label = .instantiate()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var distanceLabel: Label = {
        let label: Label = .instantiate()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var priceBackgroundView: UIView = {
        let view: UIView = .instantiate()
        view.backgroundColor = Asset.Colors.Theme.backgroundLightGray.color
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var distanceBackgroundView: UIView = {
        let view: UIView = .instantiate()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var actionButton: ButtonView = {
        let button: ButtonView = .instantiate()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private static var priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 3
        formatter.maximumFractionDigits = 3
        return formatter
    }()

    private static var decimalDistanceFormatter: MeasurementFormatter = {
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .short
        formatter.unitOptions = .providedUnit
        formatter.numberFormatter.maximumFractionDigits = 0
        formatter.numberFormatter.roundingMode = .halfEven
        return formatter
    }()

    private static var singleFractiondistanceFormatter: MeasurementFormatter = {
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .short
        formatter.unitOptions = .providedUnit
        formatter.numberFormatter.maximumFractionDigits = 1
        formatter.numberFormatter.minimumFractionDigits = 1
        return formatter
    }()

    private var actionViewHeightConstraint: NSLayoutConstraint?

    var style: DashboardItemViewStyle = .default {
        didSet { didChangeStyle() }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        didChangeStyle()
    }

    override func setup() {
        super.setup()

        [
            titleLabel,
            descriptionLabel,
            distanceBackgroundView,
            priceBackgroundView,
            actionButton
        ].forEach(addSubview)

        setupPriceView()
        setupDistanceView()

        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -150).isActive = true

        descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: priceBackgroundView.leadingAnchor, constant: -16).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true

        actionButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        actionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        actionButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        actionButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
        actionButton.topAnchor.constraint(equalTo: distanceBackgroundView.bottomAnchor, constant: 20).isActive = true
    }

    private func setupPriceView() {
        [
            fuelTypeLabel,
            priceLabel
        ].forEach(priceBackgroundView.addSubview)

        priceBackgroundView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        priceBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        priceBackgroundView.topAnchor.constraint(equalTo: descriptionLabel.topAnchor).isActive = true
        let topPrice = priceBackgroundView.bottomAnchor.constraint(lessThanOrEqualTo: actionButton.topAnchor, constant: 25)
        topPrice.priority = .defaultLow
        topPrice.isActive = true

        fuelTypeLabel.trailingAnchor.constraint(equalTo: priceBackgroundView.trailingAnchor).isActive = true
        fuelTypeLabel.leadingAnchor.constraint(equalTo: priceBackgroundView.leadingAnchor).isActive = true
        fuelTypeLabel.topAnchor.constraint(equalTo: priceBackgroundView.topAnchor, constant: 4).isActive = true

        priceLabel.trailingAnchor.constraint(equalTo: priceBackgroundView.trailingAnchor).isActive = true
        priceLabel.leadingAnchor.constraint(equalTo: priceBackgroundView.leadingAnchor).isActive = true
        priceLabel.bottomAnchor.constraint(equalTo: priceBackgroundView.bottomAnchor, constant: -5).isActive = true
        priceLabel.topAnchor.constraint(equalTo: fuelTypeLabel.bottomAnchor).isActive = true
    }

    private func setupDistanceView() {
        [
            distanceImageView,
            distanceLabel
        ].forEach(distanceBackgroundView.addSubview)

        distanceBackgroundView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 1).isActive = true
        distanceBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        distanceBackgroundView.heightAnchor.constraint(equalToConstant: 26).isActive = true

        distanceImageView.leadingAnchor.constraint(equalTo: distanceBackgroundView.leadingAnchor).isActive = true
        distanceImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        distanceImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        distanceImageView.topAnchor.constraint(equalTo: distanceBackgroundView.topAnchor, constant: 1).isActive = true

        distanceLabel.leadingAnchor.constraint(equalTo: distanceImageView.trailingAnchor, constant: 4).isActive = true
        distanceLabel.centerYAnchor.constraint(equalTo: distanceBackgroundView.centerYAnchor).isActive = true
        distanceLabel.trailingAnchor.constraint(equalTo: distanceBackgroundView.trailingAnchor).isActive = true
    }

    override func didChangeModel() {
        super.didChangeModel()

        titleLabel.text = model.title
        descriptionLabel.text = model.description
        priceBackgroundView.layer.cornerRadius = 8

        distanceLabel.text = formatDistance(withDistanceInKm: model.distance)
        actionButton.model = model.action

        didChangeStyle()

        if let price = model.price {
            priceLabel.attributedText = makePriceText(forPrice: price, currency: model.currency)
        } else {
            priceLabel.text = L10n.Price.notAvailable
        }

        if let fuelType = model.fuelType {
            fuelTypeLabel.text = fuelType.localizedDescription().localizedCapitalized
        } else {
            fuelTypeLabel.text = L10n.Price.notAvailable
        }

        if model.isPrimaryAction {
            actionButton.style = .action
        } else {
            actionButton.style = .secondaryAction
        }
    }

    private func didChangeStyle() {
        backgroundColor = style.backgroundColor
        titleLabel.style = style.titleStyle
        priceLabel.style = style.priceStyle
        fuelTypeLabel.style = style.fuelTypeStyle
        descriptionLabel.style = style.descriptionStyle
        borderStyle = style.borderStyle
        distanceImageView.tintColor = style.distanceBadgeLabelStyle.color
        layer.shadowColor = style.shadowColor.cgColor
        layer.shadowRadius = style.shadowRadius
        layer.shadowOffset = .init(width: style.shadowOffset.x, height: style.shadowOffset.y)
        layer.shadowOpacity = 1
        layer.masksToBounds = false
        distanceLabel.style = style.distanceBadgeLabelStyle
        actionButton.style = style.actionStyle
        actionViewHeightConstraint?.constant = style.actionStyle.height
    }

    private func makePriceText(forPrice price: Double, currency: String?) -> NSAttributedString {
        guard let formattedString = Self.priceFormatter.string(from: NSNumber(value: price)) else { return .init() }

        let text = NSMutableAttributedString(
            string: formattedString,
            attributes: [.font: style.priceStyle.font]
        )

        text.addAttributes([
            .font: style.priceStyle.font.withSize(
                style.priceStyle.font.pointSize * 0.75
            ),
            .baselineOffset: 8
        ], range: NSRange(location: formattedString.count - 1, length: 1))

        text.append(NSAttributedString(string: " \(currency ?? "€")", attributes: [.font: style.priceStyle.font]))

        return text
    }

    private func formatDistance(withDistanceInKm distance: Double) -> String {
        let distanceMeasurement = Measurement<UnitLength>(value: distance, unit: .kilometers)

        if distance < Constants.distanceFormattingThresholdForMetersPrecision - Constants.roundingThreshold {
            return Self.decimalDistanceFormatter.string(from: distanceMeasurement.converted(to: .meters))
        } else if distance < Constants.distanceFormattingThresholdInKm - Constants.roundingThreshold {
            return Self.singleFractiondistanceFormatter.string(from: distanceMeasurement)
        } else {
            return Self.decimalDistanceFormatter.string(from: distanceMeasurement)
        }
    }
}
