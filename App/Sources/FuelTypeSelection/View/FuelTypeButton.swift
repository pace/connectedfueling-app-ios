import SwiftUI

struct FuelTypeButton: View {
    @Binding private var selectedValue: FuelType?

    private let fuelType: FuelType
    private let iconSize: CGFloat = 25
    private let buttonWidth: CGFloat

    init(fuelType: FuelType,
         selectedValue: Binding<FuelType?>,
         buttonWidth: CGFloat = .infinity) {
        self.fuelType = fuelType
        self._selectedValue = selectedValue
        self.buttonWidth = buttonWidth
    }

    var body: some View {
        Button(action: {
            selectedValue = fuelType
        }, label: {
            HStack(spacing: .paddingM) {
                TextLabel(fuelType.localizedTitle)
                    .font(.system(size: 16, weight: .bold))
                    .padding(.leading, .paddingM)
                Spacer()
                radioButton
                    .padding(.trailing, .paddingM)
            }
            .frame(width: buttonWidth, height: 50)
        })
        .background(Color.lightGrey)
        .cornerRadius(.cornerRadius)
    }

    @ViewBuilder
    private var radioButton: some View {
        ZStack {
            Circle()
                .frame(width: 30, height: 30)
                .foregroundStyle(Color.genericWhite)
                .overlay(radioButtonOutline)
            if isSelected {
                Circle()
                    .frame(width: 15, height: 15)
                    .foregroundStyle(Color.primaryTint)
            }
        }
    }

    @ViewBuilder
    private var radioButtonOutline: some View {
        Circle()
            .stroke(isSelected ? Color.primaryTint : .genericGrey, lineWidth: 1)
    }

    var isSelected: Bool {
        fuelType == selectedValue
    }
}

#Preview {
    VStack {
        FuelTypeButton(fuelType: .cheapestDiesel,
                       selectedValue: .constant(.cheapestDiesel))
        FuelTypeButton(fuelType: .cheapestPetrol,
                       selectedValue: .constant(.cheapestPetrol))
    }
}
