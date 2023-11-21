import SwiftUI

struct FuelTypeSelectionView: View {
    @StateObject private var viewModel: FuelTypeSelectionViewModel = .init()

    var body: some View {
        VStack {
            FuelTypeButtonsGroup(fuelTypes: FuelType.selectableFilters,
                                 selectedFuelType: $viewModel.selectedFuelType)
            Spacer()
        }
        .navigationTitle(L10n.fuelSelectionTitle)
        .padding(.top, 10)
        .padding(.horizontal, 20)
    }
}

#Preview {
    NavigationView {
        FuelTypeSelectionView()
            .addNavigationBar(showsLogo: false, navigationTitle: L10n.fuelTypeSelection)
    }
}
