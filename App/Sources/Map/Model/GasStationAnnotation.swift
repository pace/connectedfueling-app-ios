import CoreLocation
import Foundation

struct GasStationAnnotation: Identifiable {
    let id: String
    let gasStation: GasStation

    var coordinate: CLLocationCoordinate2D {
        gasStation.location.coordinate
    }

    init(gasStation: GasStation) {
        self.id = gasStation.id
        self.gasStation = gasStation
    }
}
