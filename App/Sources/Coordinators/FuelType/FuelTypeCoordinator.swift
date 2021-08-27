import Domain
import JLCoordinator
import PACECloudSDK
import UIKit

final class FuelTypeCoordinator: Coordinator {
    typealias Callback = () -> Void

    private let gasStationListInteractor: GasStationListInteractor
    private let isCompact: Bool
    private var selectedFuelType: FuelType?
    private let callback: Callback?
    private lazy var viewController: OnboardingViewController = .instantiate()

    init(
        gasStationListInteractor: GasStationListInteractor,
        presenter: Presenter,
        isCompact: Bool = false,
        selectedFuelType: FuelType? = nil,
        callback: Callback? = nil
    ) {
        self.gasStationListInteractor = gasStationListInteractor
        self.callback = callback
        self.isCompact = isCompact
        self.selectedFuelType = selectedFuelType

        super.init(presenter: presenter)
    }

    override func start() {
        let isSelectedFuelTypeAvailable = selectedFuelType != nil
        viewController.model = .init(
            image: Asset.Images.fuelType.image,
            title: L10n.Onboarding.FuelType.title,
            description: L10n.Onboarding.FuelType.description,
            applyLargeTitleInset: false,
            applySecondaryActionInset: false,
            actions: FuelType.allCases.map { fuelType in
                let isNotSelectedFuelType = fuelType != selectedFuelType
                return ButtonViewModel(
                    title: localizedDescription(for: fuelType),
                    isSelected: isSelectedFuelTypeAvailable && isNotSelectedFuelType
                ) { [weak self] in
                    self?.gasStationListInteractor.setFuelType(fuelType) { _ in
                        guard let self = self else { return }

                        self.callback?()
                        self.presenter.dismiss(self.viewController, animated: true)
                        self.stop()
                    }
                }
            }
        )

        if isCompact {
            viewController.style = .compact
        }

        presenter.present(viewController, animated: true)
    }
}

// MARK: - Localization
extension FuelTypeCoordinator {
    private func localizedDescription(for fuelType: FuelType) -> String {
        switch fuelType {
        case .diesel:
            return L10n.FuelType.diesel

        case .ron95e5:
            return L10n.FuelType.super

        case .ron95e10:
            return L10n.FuelType.superE10

        case .ron98e5:
            return L10n.FuelType.superPlus
        }
    }
}
