enum ItemCreateAction: ActionProtocol {
    case dismissFlow
    case item(ItemList)
}

final class ItemCreateCoordinator: BaseCoordinator<ItemCreateAction>{
    
  private let factory: ItemCreateModuleFactory
  private let router: RouterProtocol
  
  init(router: RouterProtocol, factory: ItemCreateModuleFactory) {
    self.factory = factory
    self.router = router
  }
  
  override func start() {
    showCreate()
  }
  
  //MARK: - Run current flow's controllers
  
  private func showCreate() {
    let createItemOutput = factory.makeItemAddOutput()
    createItemOutput.onCompleteCreateItem = { [weak self] item in
      self?.listener?(.item(item))
    }
    createItemOutput.onHideButtonTap = { [weak self] in
      self?.listener?(.dismissFlow)
    }
    router.setRootModule(createItemOutput)
  }
}
