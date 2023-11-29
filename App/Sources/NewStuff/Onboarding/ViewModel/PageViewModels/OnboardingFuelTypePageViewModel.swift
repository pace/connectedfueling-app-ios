import SwiftUI

class OnboardingFuelTypePageViewModel: OnboardingPageViewModel {
    @Published private var selectedFuelType: FuelType? {
        didSet {
            isActionDisabled = selectedFuelType == nil
        }
    }

    private(set) var poiManager: POIManager

    init(poiManager: POIManager = .init()) {
        self.poiManager = poiManager

        super.init(image: .fuelType,
                   title: L10n.onboardingFuelTypeTitle,
                   description: L10n.onboardingFuelTypeDescription)

        isActionDisabled = selectedFuelType == nil
    }

    override func setupPageActions() {
        pageActions = [
            .init(title: L10n.commonUseNext, action: { [weak self] in
                self?.poiManager.fuelType = self?.selectedFuelType
                self?.finishOnboardingPage()
            })
        ]
    }

    override func additionalContent() -> AnyView? {
        AnyView(
            FuelTypeButtonsGroup(fuelTypes: FuelType.selectableFilters,
                                 selectedFuelType: .init(
                                    get: {
                                        self.selectedFuelType
                                    },
                                    set: { [weak self] in
                                        self?.selectedFuelType = $0
                                    }
                                 ))
            .padding(.top, 40)
        )
    }
}
