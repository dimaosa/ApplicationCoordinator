final class SettingsCoordinator: BaseCoordinator<EmptyAction> {
  
  private let factory: SettingsPresentableFactory
  private let router: RouterProtocol
  
  init(router: RouterProtocol, factory: SettingsPresentableFactory) {
    self.factory = factory
    self.router = router
  }
  
  override func start() {
    showSettings()
  }
  
  //MARK: - Run current flow's controllers
  
  private func showSettings() {
    let settingsFlowPresentable = factory.makeSettingsPresentable()
    router.setRootPresentable(settingsFlowPresentable)
  }
}
