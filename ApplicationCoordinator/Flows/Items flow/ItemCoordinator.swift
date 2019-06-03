final class ItemCoordinator: BaseCoordinator<EmptyAction> {
  
  private let factory: ItemPresentableFactory
  private let coordinatorFactory: CoordinatorFactoryProtocol
  private let router: RouterProtocol
  
  init(router: RouterProtocol, factory: ItemPresentableFactory, coordinatorFactory: CoordinatorFactoryProtocol) {
    self.router = router
    self.factory = factory
    self.coordinatorFactory = coordinatorFactory
  }
  
  override func start() {
    showItemList()
  }
  
  //MARK: - Run current flow's controllers
  
  private func showItemList() {
    
    let itemsPresentable = factory.makeItemsPresentable()
    itemsPresentable.onItemSelect = { [weak self] (item) in
      self?.showItemDetail(item)
    }
    itemsPresentable.onCreateItem = { [weak self] in
      self?.runCreationFlow()
    }
    router.setRootPresentable(itemsPresentable)
  }
  
  private func showItemDetail(_ item: ItemList) {
    
    let itemDetailFlowPresentable = factory.makeItemDetailPresentable(item: item)
    router.push(itemDetailFlowPresentable, hideBottomBar: true)
  }
  
  //MARK: - Run coordinators (switch to another flow)
  
  private func runCreationFlow() {
    
    let (coordinator, presentable) = coordinatorFactory.makeItemCreationCoordinatorBox()
    coordinator.listener = { [weak self, weak coordinator] action in
        self?.router.dismissPresentable()
        self?.removeDependency(coordinator)
        switch action {
        case let .item(item):
            self?.showItemDetail(item)
        case .dismissFlow:
            break
        }
    }
    addDependency(coordinator)
    router.present(presentable)
    coordinator.start()
  }
}
