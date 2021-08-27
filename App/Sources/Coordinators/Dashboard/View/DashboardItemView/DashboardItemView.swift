import JamitFoundation
import UIKit

final class DashboardItemView: StatefulView<DashboardItemViewModel> {
    enum Constants {
        static let distanceFormattingThresholdForMetersPrecision: Double = 1.0
        static let distanceFormattingThresholdInKm: Double = 10.0
        static let roundingThreshold: Double = 0.05
    }

    @IBOutlet private var iconView: UIImageView!
    @IBOutlet private var titleLabel: Label!
    @IBOutlet private var descriptionLabel: Label!
    @IBOutlet private var priceBackgroundView: UIView!
    @IBOutlet private var priceLabel: Label!
    @IBOutlet private var distanceBackgroundView: UIView!
    @IBOutlet private var distanceLabel: Label!
    @IBOutlet private var actionContainerView: UIView!
    @IBOutlet private var actionContainerViewHeightConstraint: NSLayoutConstraint!

    private lazy var actionButton: ButtonView = .instantiate()

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

    var style: DashboardItemViewStyle = .default {
        didSet { didChangeStyle() }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionContainerView.addSubview(actionButton)
        actionButton.topAnchor.constraint(equalTo: actionContainerView.topAnchor).isActive = true
        actionButton.leadingAnchor.constraint(equalTo: actionContainerView.leadingAnchor).isActive = true
        actionButton.trailingAnchor.constraint(equalTo: actionContainerView.trailingAnchor).isActive = true
        actionButton.bottomAnchor.constraint(equalTo: actionContainerView.bottomAnchor).isActive = true

        didChangeStyle()
    }

    override func didChangeModel() {
        super.didChangeModel()

        iconView.image = model.icon
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
        borderStyle = style.borderStyle
        layer.shadowColor = style.shadowColor.cgColor
        layer.shadowRadius = style.shadowRadius
        layer.shadowOffset = .init(width: style.shadowOffset.x, height: style.shadowOffset.y)
        layer.shadowOpacity = 1
        layer.masksToBounds = false
        distanceBackgroundView.backgroundColor = style.distanceBadgeBackgroundColor
        distanceBackgroundView.borderStyle = style.distanceBadgeBorderStyle
        distanceLabel.style = style.distanceBadgeLabelStyle
        actionButton.style = style.actionStyle
        actionContainerViewHeightConstraint.constant = style.actionStyle.height
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
