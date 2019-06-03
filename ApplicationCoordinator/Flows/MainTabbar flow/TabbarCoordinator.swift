class TabbarCoordinator: BaseCoordinator<EmptyAction> {
    
    private let coordinatorFactory: CoordinatorFactoryProtocol
    private let router: RouterProtocol
    private let factory: TabBarPresentableFactory
    
    init(router: RouterProtocol, coordinatorFactory: CoordinatorFactoryProtocol, presentableFactory: TabBarPresentableFactory) {
        self.router = router
        self.coordinatorFactory = coordinatorFactory
        self.factory = presentableFactory
    }
    
    override func start() {
        showTabBar()
    }
    
    private func showTabBar() {
        let presentable = factory.tabBarPresentable()
        presentable.onViewDidLoad = runItemFlow()
        presentable.onItemFlowSelect = runItemFlow()
        presentable.onSettingsFlowSelect = runSettingsFlow()
        router.setRootPresentable(presentable, hideBar: true)
    }
    
    private func runItemFlow() -> ((UINavigationController) -> ()) {
        return { [unowned self] navController in
            if navController.viewControllers.isEmpty == true {
                let itemCoordinator = self.coordinatorFactory.makeItemCoordinator(navController: navController)
                self.addDependency(itemCoordinator)
                itemCoordinator.start()
            }
        }
    }
    
    private func runSettingsFlow() -> ((UINavigationController) -> ()) {
        return { [unowned self] navController in
            if navController.viewControllers.isEmpty == true {
                let settingsCoordinator = self.coordinatorFactory.makeSettingsCoordinator(navController: navController)
                self.addDependency(settingsCoordinator)
                settingsCoordinator.start()
            }
        }
    }
}

