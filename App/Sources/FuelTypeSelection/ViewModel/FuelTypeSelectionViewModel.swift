import Foundation

class FuelTypeSelectionViewModel: ObservableObject {
    @Published var selectedFuelType: FuelType? {
        didSet {
            poiManager.fuelType = selectedFuelType
        }
    }

    private(set) var poiManager: POIManager

    init(poiManager: POIManager = .init()) {
        self.poiManager = poiManager
        self.selectedFuelType = poiManager.fuelType
    }
}
