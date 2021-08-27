import UIKit

extension UIView {
    /**
     * Adds a background view behind the status bar with the given color and is returning it
     *
     * - parameters color: The background color.
     * - returns: The embedded background view or nil if the statusBar frame height is not accessible
     */
    @discardableResult
    func addStatusBarBackgroundView(
        color: UIColor = Asset.Colors.Theme.primary.color
    ) -> UIView? {
        let view = UIView.instantiate()
        view.backgroundColor = color
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        view.topAnchor.constraint(equalTo: topAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        bringSubviewToFront(view)
        return view
    }
}
