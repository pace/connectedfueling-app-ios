import JamitFoundation
import UIKit

/// The base view controller which is a subclass of `StatefulViewController`.
class CofuViewController<Model: ViewModelProtocol>: StatefulViewController<Model> {
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    /// This method is intended to be overridden by a subclass to setup its view layout
    ///
    /// - Attention: Calling this method multiple times may result in unexpected behavior.
    func setup() {
        // Do your layouting inside this method.
    }
}