import Domain
import JLCoordinator
import PACECloudSDK
import UIKit

final class FuelTypeCoordinator: Coordinator {
    typealias Callback = () -> Void

    private let gasStationListInteractor: GasStationListInteractor
    private let isCompact: Bool
    private var selectedFuelType: Domain.FuelType?
    private let callback: Callback?
    private lazy var viewController: OnboardingViewController = .instantiate()

    init(
        gasStationListInteractor: GasStationListInteractor,
        presenter: Presenter,
        isCompact: Bool = false,
        selectedFuelType: Domain.FuelType? = nil,
        callback: Callback? = nil
    ) {
        self.gasStationListInteractor = gasStationListInteractor
        self.callback = callback
        self.isCompact = isCompact
        self.selectedFuelType = selectedFuelType

        super.init(presenter: presenter)
    }

    override func start() {
        initModel()

        if isCompact {
            viewController.style = .compact
        }

        presenter.present(viewController, animated: true)
    }

    private func initModel() {
        viewController.model = .init(
            image: Asset.Images.fuelType.image,
            title: "L10n.Onboarding.FuelType.title",
            description: "L10n.Onboarding.FuelType.description",
            applyLargeTitleInset: false,
            action: .init(title: "L10n.Onboarding.Actions.save") { [weak self] in
                guard let self = self else { return }
                self.callback?()
                self.presenter.dismiss(self.viewController, animated: true)
                self.stop()
            },
            radios: Domain.FuelType.allCases.map { fuelType in
                return ButtonViewModel(
                    icon: Asset.Images.checkmarkInactive.image,
                    selectedIcon: Asset.Images.checkmarkActive.image,
                    title: fuelType.localizedDescription(),
                    isSelected: fuelType == selectedFuelType
                ) { [weak self] in
                    guard let self = self,
                          self.selectedFuelType != fuelType else { return }
                    self.gasStationListInteractor.setFuelType(fuelType) { _ in
                        self.selectedFuelType = fuelType
                        if #available(iOS 13.0, *) {
                            self.viewController.isModalInPresentation = true
                        }
                        self.initModel()
                    }
                }
            }
        )
    }
}
