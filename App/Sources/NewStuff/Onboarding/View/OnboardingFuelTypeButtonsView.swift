import SwiftUI

struct OnboardingFuelTypeButtonsView: View {
    @Binding private var selectedFuelType: FuelType?
    @State private var fuelTypes: [FuelType]

    init(fuelTypes: [FuelType],
         selectedFuelType: Binding<FuelType?>) {
        self.fuelTypes = fuelTypes
        self._selectedFuelType = selectedFuelType
    }

    var body: some View {
        VStack {
            ForEach(fuelTypes, id: \.self) {
                OnboardingFuelTypeButton(fuelType: $0, selectedValue: $selectedFuelType)
            }
        }
    }
}

#Preview {
    OnboardingFuelTypeButtonsView(fuelTypes: FuelType.allCases,
                                  selectedFuelType: .constant(.diesel))
}
