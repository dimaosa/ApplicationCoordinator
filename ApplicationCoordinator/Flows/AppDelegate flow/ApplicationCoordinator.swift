fileprivate var onboardingWasShown = false
fileprivate var isAutorized = false

fileprivate enum LaunchInstructor {
    case main, auth, onboarding
    
    static func configure(
        tutorialWasShown: Bool = onboardingWasShown,
        isAutorized: Bool = isAutorized) -> LaunchInstructor {
        
        switch (tutorialWasShown, isAutorized) {
        case (true, false), (false, false): return .auth
        case (false, true): return .onboarding
        case (true, true): return .main
        }
    }
}

final class ApplicationCoordinator: BaseCoordinator<EmptyAction> {
    
    private let coordinatorFactory: CoordinatorFactoryProtocol
    private let router: RouterProtocol
    
    private var instructor: LaunchInstructor {
        return LaunchInstructor.configure()
    }
    
    init(router: RouterProtocol, coordinatorFactory: CoordinatorFactoryProtocol) {
        self.router = router
        self.coordinatorFactory = coordinatorFactory
    }
    
    override func start(with option: DeepLinkOption?) {
        //start with deepLink
        if let option = option {
            switch option {
            case .onboarding: runOnboardingFlow()
            case .signUp: runAuthFlow()
            default:
                children.forEach { coordinator in
                    coordinator.start(with: option)
                }
            }
            // default start
        } else {
            switch instructor {
            case .onboarding: runOnboardingFlow()
            case .auth: runAuthFlow()
            case .main: runMainFlow()
            }
        }
    }
    
    private func runAuthFlow() {
        let coordinator = coordinatorFactory.makeAuthCoordinatorBox(router: router)
        coordinator.listener = { [weak self, weak coordinator] action in
            switch action {
            case .dismissFlow:
                isAutorized = true
                self?.start()
                self?.removeDependency(coordinator)
            }
        }
        addDependency(coordinator)
        coordinator.start()
    }
    
    private func runOnboardingFlow() {
        let coordinator = coordinatorFactory.makeOnboardingCoordinator(router: router)
        coordinator.listener = { [weak self, weak coordinator] action in
            switch action {
            case .dismissFlow:
                onboardingWasShown = true
                self?.start()
                self?.removeDependency(coordinator)
            }
        }
        addDependency(coordinator)
        coordinator.start()
    }
    
    private func runMainFlow() {
        let coordinator = coordinatorFactory.makeTabbarCoordinator(router: router)
        addDependency(coordinator)
        coordinator.start()
    }
}
