import SwiftUI

class OnboardingFuelTypePageViewModel: OnboardingPageViewModel {
    @Published private var selectedFuelType: FuelType? {
        didSet {
            isActionDisabled = selectedFuelType == nil
        }
    }

    init() {
        super.init(image: .fuelType,
                   title: L10n.Onboarding.FuelType.title,
                   description: L10n.Onboarding.FuelType.description)

        isActionDisabled = selectedFuelType == nil
    }

    override func setupPageActions() {
        pageActions = [
            .init(title: L10n.Onboarding.Actions.save, action: { [weak self] in
                AppUserDefaults.set(self?.selectedFuelType, for: Constants.UserDefaults.fuelType)
                self?.finishOnboardingPage()
            })
        ]
    }

    override func additionalContent() -> AnyView? {
        AnyView(
            OnboardingFuelTypeButtonsView(fuelTypes: FuelType.allCases,
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
