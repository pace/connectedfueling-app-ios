import JLCoordinator
import UIKit

protocol PageViewPresenterDelegate: AnyObject {
    func pageViewPresenter(_ pageViewPresenter: PageViewPresenter, didUpdateIndex index: Int, count: Int)
}

final class PageViewPresenter: NSObject, Presenter {
    weak var delegate: PageViewPresenterDelegate?

    let observers: WeakCache<PresenterObserving> = .init()

    var isSwipeForwardEnabled: Bool = true {
        didSet { resetCache() }
    }

    var isSwipeBackwardEnabled: Bool = true {
        didSet { resetCache() }
    }

    private var pageViewController: UIPageViewController
    private var startedTransitionToViewController: UIViewController?
    private var viewControllers: [UIViewController] = []

    private var currentIndex: Int? {
        guard
            let presentedViewController = pageViewController.viewControllers?.first,
            let index = viewControllers.firstIndex(of: presentedViewController)
        else {
            return nil
        }

        return index
    }

    init(pageViewController: UIPageViewController) {
        self.pageViewController = pageViewController

        super.init()

        pageViewController.delegate = self

        let scrollViews = pageViewController.view.subviews.compactMap { $0 as? UIScrollView }
        scrollViews.forEach { $0.delaysContentTouches = false }
    }

    func present(_ viewController: UIViewController, animated: Bool) {
        if
            let currentIndex = currentIndex,
            let index = viewControllers.firstIndex(of: viewController),
            pageViewController.viewControllers?.first !== viewControllers[index]
        {
            pageViewController.view.isUserInteractionEnabled = false
            pageViewController.setViewControllers(
                [viewControllers[index]],
                direction: index > currentIndex  ? .forward : .reverse,
                animated: true
            ) { [weak self] completed in
                self?.pageViewController.view.isUserInteractionEnabled = true
                guard completed else { return }

                self?.notifyObserverAboutPresentation(of: viewController)
                self?.notifyDelegateAboutUpdates()
            }
        } else {
            viewControllers.append(viewController)

            // Set an initial ViewController if none is set.
            guard pageViewController.viewControllers?.isEmpty == true else { return }

            pageViewController.setViewControllers([viewController], direction: .forward, animated: true) { [weak self] completed in
                guard completed else { return }

                self?.notifyObserverAboutPresentation(of: viewController)
                self?.notifyDelegateAboutUpdates()
            }
        }
    }

    func dismiss(_ viewController: UIViewController, animated: Bool) {
        guard let index = viewControllers.firstIndex(of: viewController) else { return }

        viewControllers.remove(at: index)

        notifyObserverAboutDismiss(of: viewController)
        notifyDelegateAboutUpdates()
    }

    func dismissRoot(animated: Bool) {
        pageViewController.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }

            self.viewControllers.forEach { viewController in
                self.notifyObserverAboutDismiss(of: viewController)
            }

            self.notifyObserverAboutDismiss(of: self.pageViewController)
        }
    }

    private func notifyDelegateAboutUpdates() {
        delegate?.pageViewPresenter(self, didUpdateIndex: currentIndex ?? 0, count: viewControllers.count)
    }
}

extension PageViewPresenter: UIPageViewControllerDelegate {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        willTransitionTo pendingViewControllers: [UIViewController]
    ) {
        startedTransitionToViewController = pendingViewControllers.first
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        defer {
            startedTransitionToViewController = nil
            notifyDelegateAboutUpdates()
        }

        guard
            completed,
            let toViewController = startedTransitionToViewController
        else {
            return
        }

        if let dismissedViewController = previousViewControllers.first {
            notifyObserverAboutDismiss(of: dismissedViewController)
        }

        notifyObserverAboutPresentation(of: toViewController)
    }

    // NOTE: Cache should be resettet if paging has been enabled or disabled to force delegate call
    private func resetCache() {
        guard
            startedTransitionToViewController == nil,
            let currentIndex = currentIndex
        else {
            return
        }

        pageViewController.setViewControllers(
            [viewControllers[currentIndex]],
            direction: .forward,
            animated: false,
            completion: nil
        )
    }
}

extension PageViewPresenter {
    func nextViewController() {
        guard let currentIndex = currentIndex, (0 ..< viewControllers.count).contains(currentIndex + 1) else { return }

        let nextViewControllerIndex = viewControllers.index(after: currentIndex)
        present(viewControllers[nextViewControllerIndex], animated: true)
    }

    func index(of viewController: UIViewController) -> Int? {
        return viewControllers.firstIndex(of: viewController)
    }
}
