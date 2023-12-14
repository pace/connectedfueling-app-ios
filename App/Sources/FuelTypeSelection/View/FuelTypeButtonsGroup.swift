import SwiftUI

struct FuelTypeButtonsGroup: View {
    @Binding private var selectedFuelType: FuelType?
    @State private var fuelTypes: [FuelType]

    private let buttonWidth: CGFloat

    init(fuelTypes: [FuelType],
         selectedFuelType: Binding<FuelType?>,
         buttonWidth: CGFloat = .infinity) {
        self.fuelTypes = fuelTypes
        self._selectedFuelType = selectedFuelType
        self.buttonWidth = buttonWidth
    }

    var body: some View {
        VStack(spacing: .paddingXS) {
            ForEach(fuelTypes, id: \.self) {
                FuelTypeButton(fuelType: $0,
                               selectedValue: $selectedFuelType,
                               buttonWidth: buttonWidth)
            }
        }
    }
}

#Preview {
    FuelTypeButtonsGroup(fuelTypes: FuelType.selectableFilters,
                         selectedFuelType: .constant(.diesel))
}
