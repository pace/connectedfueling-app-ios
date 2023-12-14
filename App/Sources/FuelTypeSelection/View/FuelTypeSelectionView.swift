import SwiftUI

struct FuelTypeSelectionView: View {
    @StateObject private var viewModel: FuelTypeSelectionViewModel = .init()

    var body: some View {
        VStack {
            FuelTypeButtonsGroup(fuelTypes: FuelType.selectableFilters,
                                 selectedFuelType: $viewModel.selectedFuelType)
            Spacer()
        }
        .navigationTitle(L10n.walletFuelTypeSelectionTitle)
        .padding(.top, 10)
        .padding(.horizontal, 20)
    }
}

#Preview {
    AppNavigationView {
        FuelTypeSelectionView()
            .addNavigationBar(style: .standard(title: L10n.walletFuelTypeSelectionTitle))
    }
}
