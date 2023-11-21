import SwiftUI

struct FuelTypeButtonsGroup: View {
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
                FuelTypeButton(fuelType: $0, selectedValue: $selectedFuelType)
            }
        }
    }
}

#Preview {
    FuelTypeButtonsGroup(fuelTypes: FuelType.selectableFilters,
                         selectedFuelType: .constant(.diesel))
}
