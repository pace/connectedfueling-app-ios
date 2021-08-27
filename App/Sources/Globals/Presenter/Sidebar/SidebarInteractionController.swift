import UIKit

// swiftlint:disable:next controller_class_name_suffix
final class SidebarInteractionController: UIPercentDrivenInteractiveTransition {
    private let gestureRecognizer: UIPanGestureRecognizer
    private weak var transitionContext: UIViewControllerContextTransitioning?
    private var initialLocationInContainerView: CGPoint = .zero
    private var initialTranslationInContainerView: CGPoint = .zero

    init(gestureRecognizer: UIPanGestureRecognizer) {
        self.gestureRecognizer = gestureRecognizer

        super.init()

        gestureRecognizer.addTarget(self, action: #selector(didUpdateGesture))
    }

    deinit {
        gestureRecognizer.removeTarget(self, action: #selector(didUpdateGesture))
    }

    override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        self.initialLocationInContainerView = gestureRecognizer.location(in: transitionContext.containerView)
        self.initialTranslationInContainerView = gestureRecognizer.translation(in: transitionContext.containerView)

        super.startInteractiveTransition(transitionContext)
    }

    @objc
    private func didUpdateGesture() {
        switch gestureRecognizer.state {
        case .began:
            return

        case .changed:
            if percentComplete(for: gestureRecognizer) < 0 {
                cancel()
                gestureRecognizer.removeTarget(self, action: #selector(didUpdateGesture))
            } else {
                update(percentComplete(for: gestureRecognizer))
            }

        case .ended:
            // NOTE: The presentation could be cancelled here based on percent complete
            //       but a cancellation of dismissal causes a never ending transition
            //       which makes the navigation stack non interactive, this issue should
            //       eventually be resolved and then a cancellation could be added here..
            finish()

        default:
            cancel()
        }
    }

    private func percentComplete(for gestureRecognizer: UIPanGestureRecognizer) -> CGFloat {
        guard let containerView = transitionContext?.containerView else { return 0 }

        let translation = gestureRecognizer.translation(in: containerView)
        // swiftlint:disable:next if_as_guard
        if (translation.x > .zero && initialTranslationInContainerView.x < .zero) ||
            (translation.x < .zero && initialTranslationInContainerView.x > .zero) {
            return -1
        }

        return abs(translation.x) / containerView.bounds.width
    }
}
