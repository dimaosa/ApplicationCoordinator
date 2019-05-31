
class OnboardingCoordinator: BaseCoordinator<DismissAction> {
    private let factory: OnboardingModuleFactory
    private let router: RouterProtocol
    
    init(with factory: OnboardingModuleFactory, router: RouterProtocol) {
        self.factory = factory
        self.router = router
    }
    
    override func start() {
        showOnboarding()
    }
    
    func showOnboarding() {
        let onboardingModule = factory.makeOnboardingModule()
        onboardingModule.onFinish = { [weak self] in
            self?.listener?(.dismissFlow)
        }
        router.setRootModule(onboardingModule.uiViewController)
    }
}
