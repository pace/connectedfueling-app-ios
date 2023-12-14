import SwiftUI

class OnboardingFuelTypePageViewModel: OnboardingPageViewModel {
    @Published private var selectedFuelType: FuelType? {
        didSet {
            isActionDisabled = selectedFuelType == nil
        }
    }

    private(set) var poiManager: POIManager

    init(style: ConfigurationManager.Configuration.OnboardingStyle,
         poiManager: POIManager = .init()) {
        self.poiManager = poiManager

        super.init(style: style,
                   image: .onboardingFuelTypeIcon,
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
                                 ),
                                buttonWidth: 180)
            .padding(.horizontal, .paddingM)
            .padding(.top, .paddingL)
        )
    }
}
