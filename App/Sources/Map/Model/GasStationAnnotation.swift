import CoreLocation
import Foundation

struct GasStationAnnotation: Identifiable {
    let id = UUID()
    let gasStation: GasStation

    var coordinate: CLLocationCoordinate2D {
        gasStation.location.coordinate
    }
}
