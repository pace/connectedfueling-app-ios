import CoreLocation
import ClusterMap
import ClusterMapSwiftUI
import Foundation
import MapKit
import SwiftUI

struct GasStationAnnotation: CoordinateIdentifiable, Identifiable, Hashable {
    enum Style: Hashable {
        case single(gasStation: GasStation)
        case cluster(count: Int)
    }

    let id: UUID

    var coordinate: CLLocationCoordinate2D
    let style: Style

    init(style: Style, id: UUID, coordinate: CLLocationCoordinate2D) {
        self.id = id
        self.style = style
        self.coordinate = coordinate
    }
}

struct GasStationMapAnnotationProtocol: MapAnnotationProtocol {
    let _annotationData: _MapAnnotationData
    let value: Any

    init(_ value: some MapAnnotationProtocol) {
        self.value = value
        _annotationData = value._annotationData
    }
}
