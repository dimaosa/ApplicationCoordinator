enum ItemCreateAction: ActionProtocol {
    case dismissFlow
    case item(ItemList)
}

final class ItemCreateCoordinator: BaseCoordinator<ItemCreateAction> {
    
    private let factory: ItemCreatePresentableFactory
    private let router: RouterProtocol
    
    init(router: RouterProtocol, factory: ItemCreatePresentableFactory) {
        self.factory = factory
        self.router = router
    }
    
    override func start() {
        showCreate()
    }
    
    //MARK: - Run current flow's controllers
    
    private func showCreate() {
        let createItemPresentable = factory.makeItemAddPresentable()
        createItemPresentable.onCompleteCreateItem = { [weak self] item in
            self?.listener?(.item(item))
        }
        createItemPresentable.onHideButtonTap = { [weak self] in
            self?.listener?(.dismissFlow)
        }
        router.setRootPresentable(createItemPresentable)
    }
}

