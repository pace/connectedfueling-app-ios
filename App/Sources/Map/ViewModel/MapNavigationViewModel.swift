import SwiftUI

class MapNavigationViewModel: NSObject, ObservableObject {
    @Published var alert: Alert?

    func showAlert(_ alert: Alert) {
        self.alert = alert
    }
}
