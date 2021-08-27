import JLCoordinator
import UIKit

final class SidebarPresenter: NSObject, Presenter {
    private let presentingViewController: UIViewController
    private let interactionGestureRecognizer: UIPanGestureRecognizer?
    private var presentationController: SidebarPresentationController?

    let observers: WeakCache<PresenterObserving> = .init()

    init(
        interactionGestureRecognizer: UIPanGestureRecognizer?,
        presentingViewController: UIViewController
    ) {
        self.interactionGestureRecognizer = interactionGestureRecognizer
        self.presentingViewController = presentingViewController
    }

    func present(_ viewController: UIViewController, animated: Bool) {
        let isInteractive = interactionGestureRecognizer?.state == .began

        presentationController = SidebarPresentationController(
            interactionGestureRecognizer: isInteractive ? interactionGestureRecognizer : nil,
            presentedViewController: viewController,
            presenting: presentingViewController
        ) { [weak self] in
            self?.notifyObserverAboutDismiss(of: viewController)
        }

        viewController.modalPresentationStyle = .custom
        viewController.transitioningDelegate = presentationController
        presentingViewController.present(viewController, animated: animated) { [weak self] in
            self?.notifyObserverAboutPresentation(of: viewController)
        }
    }

    func dismiss(_ viewController: UIViewController, animated: Bool) {
        presentationController = SidebarPresentationController(
            interactionGestureRecognizer: nil,
            presentedViewController: viewController,
            presenting: presentingViewController
        ) { [weak self] in
            self?.notifyObserverAboutDismiss(of: viewController)
        }

        viewController.modalPresentationStyle = .custom
        viewController.transitioningDelegate = presentationController
        viewController.dismiss(animated: animated) { [weak self] in
            self?.presentationController = nil
            self?.notifyObserverAboutDismiss(of: viewController)
        }
    }

    func dismissRoot(animated: Bool) { /* NOP */ }
}
