protocol CoordinatorFactoryProtocol {
    
    func makeTabbarCoordinator() -> (configurator: Coordinator, toPresent: Presentable?)
    func makeAuthCoordinatorBox(router: RouterProtocol) -> AuthCoordinator
    
    func makeOnboardingCoordinator(router: RouterProtocol) -> OnboardingCoordinator
    
    func makeItemCoordinator(navController: UINavigationController?) -> Coordinator
    func makeItemCoordinator() -> Coordinator
    
    func makeSettingsCoordinator() -> Coordinator
    func makeSettingsCoordinator(navController: UINavigationController?) -> Coordinator
    
    func makeItemCreationCoordinatorBox() -> (configurator: ItemCreateCoordinator, toPresent: Presentable?)
    
    func makeItemCreationCoordinatorBox(navController: UINavigationController?) -> (configurator: ItemCreateCoordinator, toPresent: Presentable?)
}

final class CoordinatorFactory: CoordinatorFactoryProtocol {
    
    func makeTabbarCoordinator() -> (configurator: Coordinator, toPresent: Presentable?) {
        let controller = TabbarController.controllerFromStoryboard(.main)
        let coordinator = TabbarCoordinator(tabbarPresentable: controller, coordinatorFactory: CoordinatorFactory())
        return (coordinator, controller)
    }
    
    func makeAuthCoordinatorBox(router: RouterProtocol) -> AuthCoordinator {
        let coordinator = AuthCoordinator(router: router, factory: ModuleFactoryImp())
        return coordinator
    }
    
    func makeItemCoordinator() -> Coordinator {
        return makeItemCoordinator(navController: nil)
    }
    
    func makeOnboardingCoordinator(router: RouterProtocol) -> OnboardingCoordinator {
        return OnboardingCoordinator(with: ModuleFactoryImp(), router: router)
    }
    
    func makeItemCoordinator(navController: UINavigationController?) -> Coordinator {
        return ItemCoordinator(router: router(navController), factory: ModuleFactoryImp(), coordinatorFactory: CoordinatorFactory())
    }
    
    func makeSettingsCoordinator() -> Coordinator {
        return makeSettingsCoordinator(navController: nil)
    }
    
    func makeSettingsCoordinator(navController: UINavigationController? = nil) -> Coordinator {
        let coordinator = SettingsCoordinator(router: router(navController), factory: ModuleFactoryImp())
        return coordinator
    }
    
    func makeItemCreationCoordinatorBox() -> (configurator: ItemCreateCoordinator, toPresent: Presentable?) {
        return makeItemCreationCoordinatorBox(navController: navigationController(nil))
    }
    
    func makeItemCreationCoordinatorBox(navController: UINavigationController?) -> (configurator: ItemCreateCoordinator, toPresent: Presentable?) {
        
        let router = self.router(navController)
        let coordinator = ItemCreateCoordinator(router: router, factory: ModuleFactoryImp())
        return (coordinator, router)
    }
    
    private func router(_ navController: UINavigationController?) -> RouterProtocol {
        return Router(rootController: navigationController(navController))
    }
    
    private func navigationController(_ navController: UINavigationController?) -> UINavigationController {
        if let navController = navController { return navController }
        else { return UINavigationController.controllerFromStoryboard(.main) }
    }
}
