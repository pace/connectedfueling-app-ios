import MapKit
import SwiftUI

// Calculation of zoom level
// https://github.com/d-babych/mapkit-wrap
// https://medium.com/@dmytrobabych/getting-actual-rotation-and-zoom-level-for-mapkit-mkmapview-e7f03f430aa9
extension MKCoordinateRegion {
    var zoomLevel: Int {
        zoom
    }

    /**
     Calculates the current zoom level of the mapView
     - returns: The current zoom level
     */
    private var zoom: Int {
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        let heightOffset: Double = 20 // the offset (status bar height) which is taken by MapKit into consideration to calculate visible area height

        // calculating Longitude span corresponding to normal (non-rotated) width
        let nonRotatedWidth = (width * cos(0) + (height - heightOffset) * sin(0))

        guard nonRotatedWidth != 0 else { return 0 }

        let spanStraight = (width * self.span.longitudeDelta / nonRotatedWidth) * 0.5 // Decrease spanStraight to increase the viewport
        let zoomLevel = log2(360 * ((width / 128) / spanStraight))

        return Int(zoomLevel)
    }
}
