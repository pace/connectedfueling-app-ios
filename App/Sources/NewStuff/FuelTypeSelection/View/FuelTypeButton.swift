import SwiftUI

struct FuelTypeButton: View {
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
            HStack(spacing: 20) {
                TextLabel(fuelType.localizedTitle)
                    .font(.system(size: 14, weight: .semibold))
                    .padding(.leading, 20)
                Spacer()
                radioButton
                    .padding(.trailing, 20)
            }
            .frame(maxWidth: .infinity, minHeight: 50)
        })
        .background(Color.lightGrey)
        .cornerRadius(12)
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
        FuelTypeButton(fuelType: .diesel,
                       selectedValue: .constant(.diesel))
        FuelTypeButton(fuelType: .ron95e5,
                       selectedValue: .constant(.diesel))
    }
}
