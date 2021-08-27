import JamitFoundation
import UIKit

final class PageIndicatorView: StatefulView<PageIndicatorViewModel> {
    private lazy var containerView: UIStackView = .instantiate()

    var style: PageIndicatorViewStyle = .default {
        didSet { didChangeStyle() }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        containerView.axis = .horizontal
        containerView.alignment = .center
        containerView.distribution = .fillEqually
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        didChangeStyle()
    }

    override func didChangeModel() {
        super.didChangeModel()

        let indicatorViews = containerView.arrangedSubviews.prefix(model.count)
        containerView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        indicatorViews.forEach { view in containerView.addArrangedSubview(view) }
        if indicatorViews.count < model.count {
            (indicatorViews.count ..< model.count).forEach { _ in
                let view = UIView.instantiate()
                view.borderStyle = .init(radius: .all(1.5))
                view.heightAnchor.constraint(equalToConstant: 3).isActive = true
                containerView.addArrangedSubview(view)
            }
        }

        didChangeStyle()
    }

    private func didChangeStyle() {
        containerView.spacing = style.spacing
        containerView.arrangedSubviews.enumerated().forEach { index, view in
            let isActive = index == model.index
            view.backgroundColor = isActive ? style.foregroundColor : style.backgroundColor
        }
    }
}

// MARK: - PageViewPresenterDelegate
extension PageIndicatorView: PageViewPresenterDelegate {
    func pageViewPresenter(_ pageViewPresenter: PageViewPresenter, didUpdateIndex index: Int, count: Int) {
        model.index = index
    }
}
