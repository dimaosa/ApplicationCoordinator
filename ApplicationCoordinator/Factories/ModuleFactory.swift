protocol ModuleFactoryProtocol: AuthModuleFactory, OnboardingModuleFactory, ItemModuleFactory, ItemCreateModuleFactory, SettingsModuleFactory, TabBarModuleFactory {}

final class ModuleFactory: ModuleFactoryProtocol {
    
    // MARK: - ---------------------- AuthModuleFactory --------------------------
    //
    func makeLoginOutput() -> LoginPresentable {
        return LoginController.controllerFromStoryboard(.auth)
    }
    
    func makeSignUpHandler() -> SignUpPresentable {
        return SignUpController.controllerFromStoryboard(.auth)
    }
    
    func makeTermsOutput() -> TermsPresentable {
        return TermsController.controllerFromStoryboard(.auth)
    }
    
    // MARK: - ---------------------- OnboardingModuleFactory --------------------------
    //
    func makeOnboardingModule() -> OnboardingPresentable {
        return OnboardingController.controllerFromStoryboard(.onboarding)
    }
    
    // MARK: - ---------------------- ItemModuleFactory --------------------------
    //
    func makeItemsOutput() -> ItemsListPresentable {
        return ItemsListController.controllerFromStoryboard(.items)
    }
    
    func makeItemDetailOutput(item: ItemList) -> ItemDetailPresentable {
        let controller = ItemDetailController.controllerFromStoryboard(.items)
        controller.itemList = item
        return controller
    }
    
    // MARK: - ---------------------- ItemCreateModuleFactory --------------------------
    //
    func makeItemAddOutput() -> ItemCreatePresentable {
        return ItemCreateController.controllerFromStoryboard(.create)
    }
    
    // MARK: - ---------------------- SettingsModuleFactory --------------------------
    //
    func makeSettingsOutput() -> SettingsPresentable {
        return SettingsController.controllerFromStoryboard(.settings)
    }
    
    // MARK: - ---------------------- TabBarModuleFactory --------------------------
    //
    func tabBarModule() -> TabbarPresentable {
        return TabbarController.controllerFromStoryboard(.tabBar)
    }
}
