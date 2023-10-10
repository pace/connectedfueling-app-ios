import SwiftUI

struct OnboardingFuelTypeButton: View {
    @Binding private var selectedValue: FuelType?

    private let fuelType: FuelType
    private let iconSize: CGFloat = 25

    init(fuelType: FuelType,
         selectedValue: Binding<FuelType?>) {
        self.fuelType = fuelType
        self._selectedValue = selectedValue
    }

    var body: some View {
        Button(action: {
            selectedValue = fuelType
        }, label: {
            Image(isSelected ? .checkmarkActive : .checkmarkInactive)
                .tint(Color.primaryTint)
                .frame(width: iconSize, height: iconSize)
                .padding(.leading, 20)
            Text(fuelType.localizedTitle)
                .frame(maxWidth: .infinity, minHeight: 50)
                .foregroundStyle(Color.primaryTint)
                .font(.system(size: 14, weight: .semibold))
                .padding(.trailing, iconSize)
        })
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.primaryTint, lineWidth: 1))
        .padding(.horizontal, Constants.View.defaultButtonPadding)
    }

    var isSelected: Bool {
        fuelType == selectedValue
    }
}

#Preview {
    VStack {
        OnboardingFuelTypeButton(fuelType: .diesel,
                                 selectedValue: .constant(.diesel))
        OnboardingFuelTypeButton(fuelType: .ron95e5,
                                 selectedValue: .constant(.diesel))
    }
}
