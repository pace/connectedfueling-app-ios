import Foundation

class FuelTypeSelectionViewModel: ObservableObject {
    @Published var selectedFuelType: FuelType? {
        didSet {
            guard let selectedFuelType else { return }
            poiManager.fuelType = selectedFuelType
        }
    }

    private(set) var poiManager: POIManager

    init(poiManager: POIManager = .init()) {
        self.poiManager = poiManager
        self.selectedFuelType = poiManager.fuelType
    }
}
