protocol CoordinatorFactoryProtocol {
    
    func makeTabbarCoordinator(router: RouterProtocol) -> Coordinator
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
    
    func makeTabbarCoordinator(router: RouterProtocol) -> Coordinator {
        return TabbarCoordinator(router: router, coordinatorFactory: CoordinatorFactory(), presentableFactory: PresentableFactory())
    }
    
    func makeAuthCoordinatorBox(router: RouterProtocol) -> AuthCoordinator {
        return AuthCoordinator(router: router, factory: PresentableFactory())
    }
    
    func makeItemCoordinator() -> Coordinator {
        return makeItemCoordinator(navController: nil)
    }
    
    func makeOnboardingCoordinator(router: RouterProtocol) -> OnboardingCoordinator {
        return OnboardingCoordinator(with: PresentableFactory(), router: router)
    }
    
    func makeItemCoordinator(navController: UINavigationController?) -> Coordinator {
        return ItemCoordinator(router: router(navController), factory: PresentableFactory(), coordinatorFactory: CoordinatorFactory())
    }
    
    func makeSettingsCoordinator() -> Coordinator {
        return makeSettingsCoordinator(navController: nil)
    }
    
    func makeSettingsCoordinator(navController: UINavigationController? = nil) -> Coordinator {
        return SettingsCoordinator(router: router(navController), factory: PresentableFactory())
    }
    
    func makeItemCreationCoordinatorBox() -> (configurator: ItemCreateCoordinator, toPresent: Presentable?) {
        return makeItemCreationCoordinatorBox(navController: navigationController(nil))
    }
    
    func makeItemCreationCoordinatorBox(navController: UINavigationController?) -> (configurator: ItemCreateCoordinator, toPresent: Presentable?) {
        
        let router = self.router(navController)
        let coordinator = ItemCreateCoordinator(router: router, factory: PresentableFactory())
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
