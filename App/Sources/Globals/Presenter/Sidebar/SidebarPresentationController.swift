import UIKit

// swiftlint:disable:next controller_class_name_suffix
final class SidebarPresentationController: UIPresentationController {
    typealias DismissAction = () -> Void

    private lazy var dimmingView: UIView = makeDimmingView()
    private lazy var dismissGestureRecognizer: UIPanGestureRecognizer = .init(
        target: self,
        action: #selector(didTriggerInteractiveDismissAction)
    )

    private var presentationContainerView: UIView!
    private var interactionGestureRecognizer: UIPanGestureRecognizer?
    private var interactionController: SidebarInteractionController?
    private let dismissAction: DismissAction

    override var presentedView: UIView? { presentationContainerView }

    init(
        interactionGestureRecognizer: UIPanGestureRecognizer?,
        presentedViewController: UIViewController,
        presenting presentingViewController: UIViewController?,
        dismissAction: @escaping DismissAction
    ) {
        self.interactionGestureRecognizer = interactionGestureRecognizer
        self.interactionController = interactionGestureRecognizer.flatMap { gestureRecognizer in
            SidebarInteractionController(gestureRecognizer: gestureRecognizer)
        }
        self.dismissAction = dismissAction

        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }

    override func presentationTransitionWillBegin() {
        guard let presentedViewControllerView = super.presentedView else { return }

        let presentationContainerView = UIView(frame: frameOfPresentedViewInContainerView)
        self.presentationContainerView = presentationContainerView

        presentedViewControllerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        presentedViewControllerView.frame = presentationContainerView.bounds
        presentationContainerView.addSubview(presentedViewControllerView)

        dimmingView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        containerView?.addSubview(dimmingView)

        dimmingView.alpha = 0
        presentingViewController.transitionCoordinator?.animate(
            alongsideTransition: { [weak dimmingView] _ in
                dimmingView?.alpha = 0.5
            },
            completion: nil
        )
    }

    override func dismissalTransitionWillBegin() {
        presentingViewController.transitionCoordinator?.animate(
            alongsideTransition: { [weak dimmingView] _ in
                dimmingView?.alpha = 0
            },
            completion: nil
        )
    }

    override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        super.preferredContentSizeDidChange(forChildContentContainer: container)

        if container === presentedViewController {
            containerView?.setNeedsLayout()
        }
    }

    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        if let viewController = container as? UIViewController, container === presentedViewController {
            return viewController.preferredContentSize
        }

        return super.size(forChildContentContainer: container, withParentContainerSize: parentSize)
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        let frame = super.frameOfPresentedViewInContainerView
        return frame.inset(by: .init(top: 0, left: 0, bottom: 0, right: frame.width * 0.12))
    }

    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()

        dimmingView.frame = containerView?.bounds ?? .zero
        presentationContainerView.frame = frameOfPresentedViewInContainerView
    }

    private func makeDimmingView() -> UIView {
        let view = UIView(frame: containerView?.bounds ?? .zero)
        view.backgroundColor = .black
        view.isOpaque = false
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTriggerDismissAction)))
        return view
    }
}

extension SidebarPresentationController: UIViewControllerTransitioningDelegate {
    func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        return self
    }

    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        return self
    }

    func animationController(
        forDismissed dismissed: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}

extension SidebarPresentationController: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return (transitionContext?.isAnimated ?? false) ? 0.3 : 0
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let isPresenting = transitionContext.viewController(forKey: .from) === presentingViewController
        if isPresenting {
            return animatePresentation(using: transitionContext)
        } else {
            return animateDismissal(using: transitionContext)
        }
    }

    private func animatePresentation(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let toViewController = transitionContext.viewController(forKey: .to),
            let toView = transitionContext.view(forKey: .to)
        else {
            return
        }

        var toViewInitialFrame = transitionContext.initialFrame(for: toViewController)
        let toViewFinalFrame = transitionContext.finalFrame(for: toViewController)

        transitionContext.containerView.addSubview(toView)
        transitionContext.containerView.addGestureRecognizer(dismissGestureRecognizer)
        toViewInitialFrame.origin = toViewFinalFrame.offsetBy(dx: -toViewFinalFrame.width, dy: 0).origin
        toViewInitialFrame.size = toViewFinalFrame.size
        toView.frame = toViewInitialFrame

        let duration = transitionDuration(using: transitionContext)
        // swiftlint:disable:next multiline_arguments
        UIView.animate(withDuration: duration) {
            toView.frame = toViewFinalFrame
        } completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }

    private func animateDismissal(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromViewController = transitionContext.viewController(forKey: .from),
            let fromView = transitionContext.view(forKey: .from)
        else {
            return
        }

        var fromViewFinalFrame = transitionContext.finalFrame(for: fromViewController)
        fromViewFinalFrame = fromView.frame.offsetBy(dx: -fromView.frame.width, dy: 0)

        let duration = transitionDuration(using: transitionContext)
        // swiftlint:disable:next multiline_arguments
        UIView.animate(withDuration: duration) {
            fromView.frame = fromViewFinalFrame
        } completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }

    @objc
    private func didTriggerDismissAction() {
        interactionController = nil
        presentingViewController.dismiss(animated: true, completion: dismissAction)
    }

    @objc
    private func didTriggerInteractiveDismissAction(in gestureRecognizer: UIPanGestureRecognizer) {
        interactionController = .init(gestureRecognizer: gestureRecognizer)
        presentingViewController.dismiss(animated: true, completion: dismissAction)
    }

    func interactionControllerForPresentation(
        using animator: UIViewControllerAnimatedTransitioning
    ) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }

    func interactionControllerForDismissal(
        using animator: UIViewControllerAnimatedTransitioning
    ) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }
}
