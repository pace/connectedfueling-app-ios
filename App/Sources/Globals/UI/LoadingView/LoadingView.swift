import JamitFoundation
import UIKit

final class LoadingView: StatefulView<LoadingViewModel> {
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var titleLabel: Label!
    @IBOutlet private var descriptionLabel: Label!

    override func didChangeModel() {
        super.didChangeModel()

        imageView.image = model.image
        titleLabel.text = model.title
        descriptionLabel.text = model.description
    }
}
