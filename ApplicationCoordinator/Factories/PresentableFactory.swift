protocol PresentableFactoryProtocol: AuthPresentableFactory, OnboardingPresentableFactory, ItemPresentableFactory, ItemCreatePresentableFactory, SettingsPresentableFactory, TabBarPresentableFactory {}

final class PresentableFactory: PresentableFactoryProtocol {
    
    // MARK: - ---------------------- AuthPresentableFactory --------------------------
    //
    func makeLoginPresentable() -> LoginPresentable {
        return LoginController.controllerFromStoryboard(.auth)
    }
    
    func makeSignUpPresentable() -> SignUpPresentable {
        return SignUpController.controllerFromStoryboard(.auth)
    }
    
    func makeTermsPresentable() -> TermsPresentable {
        return TermsController.controllerFromStoryboard(.auth)
    }
    
    // MARK: - ---------------------- OnboardingPresentableFactory --------------------------
    //
    func makeOnboardingPresentable() -> OnboardingPresentable {
        return OnboardingController.controllerFromStoryboard(.onboarding)
    }
    
    // MARK: - ---------------------- ItemPresentableFactory --------------------------
    //
    func makeItemsPresentable() -> ItemsListPresentable {
        return ItemsListController.controllerFromStoryboard(.items)
    }
    
    func makeItemDetailPresentable(item: ItemList) -> ItemDetailPresentable {
        let controller = ItemDetailController.controllerFromStoryboard(.items)
        controller.itemList = item
        return controller
    }
    
    // MARK: - ---------------------- ItemCreatePresentableFactory --------------------------
    //
    func makeItemAddPresentable() -> ItemCreatePresentable {
        return ItemCreateController.controllerFromStoryboard(.create)
    }
    
    // MARK: - ---------------------- SettingsPresentableFactory --------------------------
    //
    func makeSettingsPresentable() -> SettingsPresentable {
        return SettingsController.controllerFromStoryboard(.settings)
    }
    
    // MARK: - ---------------------- TabBarPresentableFactory --------------------------
    //
    func tabBarPresentable() -> TabbarPresentable {
        return TabbarController.controllerFromStoryboard(.tabBar)
    }
}
