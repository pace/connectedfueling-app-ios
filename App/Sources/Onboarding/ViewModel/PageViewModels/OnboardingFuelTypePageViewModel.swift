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
                guard let selectedFuelType = self?.selectedFuelType else { return }
                self?.poiManager.fuelType = selectedFuelType
                self?.finishOnboardingPage()
            })
        ]
    }

    override func additionalContent() -> AnyView? {
        AnyView(
            FuelTypeButtonsGroup(fuelTypes: FuelType.selectableFilters,
                                 selectedFuelType: .init(
                                    get: { [weak self] in
                                        self?.selectedFuelType
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
