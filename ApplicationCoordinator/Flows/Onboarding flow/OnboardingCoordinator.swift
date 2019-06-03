
class OnboardingCoordinator: BaseCoordinator<DismissAction> {
    private let factory: OnboardingPresentableFactory
    private let router: RouterProtocol
    
    init(with factory: OnboardingPresentableFactory, router: RouterProtocol) {
        self.factory = factory
        self.router = router
    }
    
    override func start() {
        showOnboarding()
    }
    
    func showOnboarding() {
        let onboardingPresentable = factory.makeOnboardingPresentable()
        onboardingPresentable.onFinish = { [weak self] in
            self?.listener?(.dismissFlow)
        }
        router.setRootPresentable(onboardingPresentable.uiViewController)
    }
}
