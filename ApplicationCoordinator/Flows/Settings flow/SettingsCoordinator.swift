final class SettingsCoordinator: BaseCoordinator<EmptyAction> {
  
  private let factory: SettingsModuleFactory
  private let router: RouterProtocol
  
  init(router: RouterProtocol, factory: SettingsModuleFactory) {
    self.factory = factory
    self.router = router
  }
  
  override func start() {
    showSettings()
  }
  
  //MARK: - Run current flow's controllers
  
  private func showSettings() {
    let settingsFlowOutput = factory.makeSettingsOutput()
    router.setRootModule(settingsFlowOutput)
  }
}
