final class ItemCoordinator: BaseCoordinator<EmptyAction> {
  
  private let factory: ItemModuleFactory
  private let coordinatorFactory: CoordinatorFactoryProtocol
  private let router: RouterProtocol
  
  init(router: RouterProtocol, factory: ItemModuleFactory, coordinatorFactory: CoordinatorFactoryProtocol) {
    self.router = router
    self.factory = factory
    self.coordinatorFactory = coordinatorFactory
  }
  
  override func start() {
    showItemList()
  }
  
  //MARK: - Run current flow's controllers
  
  private func showItemList() {
    
    let itemsOutput = factory.makeItemsOutput()
    itemsOutput.onItemSelect = { [weak self] (item) in
      self?.showItemDetail(item)
    }
    itemsOutput.onCreateItem = { [weak self] in
      self?.runCreationFlow()
    }
    router.setRootModule(itemsOutput)
  }
  
  private func showItemDetail(_ item: ItemList) {
    
    let itemDetailFlowOutput = factory.makeItemDetailOutput(item: item)
    router.push(itemDetailFlowOutput, hideBottomBar: true)
  }
  
  //MARK: - Run coordinators (switch to another flow)
  
  private func runCreationFlow() {
    
    let (coordinator, module) = coordinatorFactory.makeItemCreationCoordinatorBox()
    coordinator.listener = { [weak self, weak coordinator] action in
        self?.router.dismissModule()
        self?.removeDependency(coordinator)
        switch action {
        case let .item(item):
            self?.showItemDetail(item)
        case .dismissFlow:
            break
        }
    }
    addDependency(coordinator)
    router.present(module)
    coordinator.start()
  }
}
