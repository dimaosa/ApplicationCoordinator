class TabbarCoordinator: BaseCoordinator<EmptyAction> {
    
    private let tabbarPresentable: TabbarPresentable
    private let coordinatorFactory: CoordinatorFactoryProtocol
    
    init(tabbarPresentable: TabbarPresentable, coordinatorFactory: CoordinatorFactoryProtocol) {
        self.tabbarPresentable = tabbarPresentable
        self.coordinatorFactory = coordinatorFactory
    }
    
    override func start() {
        tabbarPresentable.onViewDidLoad = runItemFlow()
        tabbarPresentable.onItemFlowSelect = runItemFlow()
        tabbarPresentable.onSettingsFlowSelect = runSettingsFlow()
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

