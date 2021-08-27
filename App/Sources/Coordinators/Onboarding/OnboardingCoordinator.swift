import Domain
import JLCoordinator
import UIKit

final class OnboardingCoordinator: Coordinator {
    typealias Callback = () -> Void

    private let callback: Callback
    private var locationRepository: LocationRepository
    private var gasStationListInteractor: GasStationListInteractor
    private var paymentInteractor: PaymentInteractor

    private lazy var pageViewController: UIPageViewController = .init(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal,
        options: nil
    )
    private lazy var pageIndicatorView: PageIndicatorView = .instantiate()
    private lazy var pageViewPresenter: PageViewPresenter = .init(pageViewController: pageViewController)
    private lazy var authenticationViewController: OnboardingViewController = .instantiate()
    private lazy var authenticationCoordinator: AuthenticationCoordinator = .init(
        presenter: pageViewPresenter,
        modalPresenter: ModalPresenter(presentingViewController: pageViewController)
    ) { [weak self] success in
        if success {
            self?.startTwoFactorAuthenticationCoordinator()
        }

        self?.presentNextPage()
    }
    private lazy var paymentMethodViewController: OnboardingViewController = .instantiate()
    private var twoFactorAuthenticationCoordinator: TwoFactorAuthenticationCoordinator?
    private lazy var fuelTypeCoordinator: FuelTypeCoordinator = .init(
        gasStationListInteractor: gasStationListInteractor,
        presenter: pageViewPresenter,
        isCompact: false
    ) { [weak self] in
        self?.callback()
    }

    init(
        locationRepository: LocationRepository,
        gasStationListInteractor: GasStationListInteractor,
        paymentInteractor: PaymentInteractor,
        presenter: Presenter,
        callback: @escaping Callback
    ) {
        self.locationRepository = locationRepository
        self.gasStationListInteractor = gasStationListInteractor
        self.paymentInteractor = paymentInteractor
        self.callback = callback

        super.init(presenter: presenter)
    }

    override func start() {
        pageViewController.view.addStatusBarBackgroundView()
        pageViewController.view.backgroundColor = OnboardingViewStyle.regular.backgroundColor
        pageViewController.view.addSubview(pageIndicatorView)
        pageIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        pageIndicatorView.centerYAnchor.constraint(equalTo: pageViewController.view.bottomAnchor, constant: -40).isActive = true
        pageIndicatorView.leadingAnchor.constraint(equalTo: pageViewController.view.leadingAnchor, constant: 80).isActive = true
        pageIndicatorView.trailingAnchor.constraint(equalTo: pageViewController.view.trailingAnchor, constant: -80).isActive = true
        pageIndicatorView.heightAnchor.constraint(equalToConstant: 3).isActive = true
        pageIndicatorView.model = .init(index: 0, count: 5)
        pageViewPresenter.delegate = pageIndicatorView
        presenter.present(pageViewController, animated: true)

        startPermissionCoordinator()
        startAuthenticationCoordinator()
    }

    private func presentPaymentMethodSelection() {
        guard !paymentMethodViewController.isBeingPresented else { return }

        paymentMethodViewController.model = .init(
            image: Asset.Images.paymentMethod.image,
            title: L10n.Onboarding.PaymentMethod.title,
            description: L10n.Onboarding.PaymentMethod.description,
            actions: [
                .init(title: L10n.Onboarding.Actions.addPaymentMethod) { [weak self] in
                    self?.startPaymentMethodCoordinator()
                }
            ]
        )

        pageViewPresenter.present(paymentMethodViewController, animated: true)

        paymentMethodViewController.model.isLoading = true
        paymentInteractor.hasPaymentMethods { [weak self] result in
            guard let self = self else { return }

            self.paymentMethodViewController.model.isLoading = false

            let isBeingPresented = self.paymentMethodViewController === self.pageViewController.viewControllers?.first
            if case .success(true) = result, isBeingPresented {
                self.presentNextPage()
            }
        }
    }

    private func presentFuelTypeSelection() {
        guard fuelTypeCoordinator.parentCoordinator == nil else { return }

        add(childCoordinator: fuelTypeCoordinator)
        fuelTypeCoordinator.start()
    }

    private func presentNextPage() {
        pageViewPresenter.nextViewController()
    }
}

// MARK: - Flow
extension OnboardingCoordinator {
    private func startPermissionCoordinator() {
        let coordinator = PermissionCoordinator(
            locationRepository: locationRepository,
            presenter: pageViewPresenter
        ) { [weak self] in
            DispatchQueue.main.async {
                self?.presentNextPage()
            }
        }

        add(childCoordinator: coordinator)
        coordinator.start()
    }

    private func startAuthenticationCoordinator() {
        guard authenticationCoordinator.parentCoordinator == nil else { return }

        add(childCoordinator: authenticationCoordinator)
        authenticationCoordinator.start()
    }

    private func startTwoFactorAuthenticationCoordinator() {
        guard twoFactorAuthenticationCoordinator == nil else { return }

        let coordinator = TwoFactorAuthenticationCoordinator(
            presenter: pageViewPresenter
        ) { [weak self] success in
            guard success else { return }

            self?.presentPaymentMethodSelection()
            self?.presentFuelTypeSelection()
            self?.presentNextPage()
        }

        twoFactorAuthenticationCoordinator = coordinator
        add(childCoordinator: coordinator)
        coordinator.start()
    }

    private func startPaymentMethodCoordinator() {
        let coordinator = PaymentMethodCoordinator(
            presenter: ModalPresenter(presentingViewController: pageViewController)
        ) { [weak self] in
            self?.presentNextPage()
        }

        add(childCoordinator: coordinator)
        coordinator.start()
    }
}
