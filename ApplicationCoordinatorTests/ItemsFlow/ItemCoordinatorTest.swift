//
//  ItemCoordinatorTest.swift
//  ApplicationCoordinator
//
//  Created by Andrey on 18.09.16.
//  Copyright © 2016 Andrey Panov. All rights reserved.
//

import XCTest
@testable import ApplicationCoordinator

class ItemCoordinatorTest: XCTestCase {
    
    private var coordinator: Coordinator!
    private var router: RouterMockProtocol!
    
    private var itemListPresentable: ItemsListPresentable!
    private var itemDetailPresentable: ItemDetailPresentable!
    
    override func setUp() {
        super.setUp()
        
        router = RouterMock()
        
        let itemListController = ItemsListController.controllerFromStoryboard(.items)
        let itemDetailController = ItemDetailController.controllerFromStoryboard(.items)
        let factory = ItemPresentableFactoryMock(itemListController: itemListController, itemDetailCntroller: itemDetailController)
        
        coordinator = ItemCoordinator(router: router, factory: factory, coordinatorFactory: CoordinatorFactory())
        itemListPresentable = itemListController
        itemDetailPresentable = itemDetailController
        
    }
    
    override func tearDown() {
        coordinator = nil
        router = nil
        itemListPresentable = nil
        itemDetailPresentable = nil
        
        super.tearDown()
    }
    
    func testStart() {
        
        coordinator.start()
        // login controller must be in navigation stack
        XCTAssertTrue(router.navigationStack.first is ItemsListController)
        XCTAssertTrue(router.navigationStack.count == 1)
    }
    
    func testShowItemDetail() {
        
        coordinator.start()
        itemListPresentable.onItemSelect!(ItemList(title: "", subtitle: ""))
        XCTAssertTrue(router.navigationStack.last is ItemDetailController)
        XCTAssertTrue(router.navigationStack.count == 2)
    }
}

final class ItemPresentableFactoryMock: ItemPresentableFactory {
    
    private let itemListController: ItemsListController
    private let itemDetailCntroller: ItemDetailController
    
    init(itemListController: ItemsListController,
         itemDetailCntroller: ItemDetailController) {
        
        self.itemListController = itemListController
        self.itemDetailCntroller = itemDetailCntroller
    }
    
    func makeItemsPresentable() -> ItemsListPresentable {
        return itemListController
    }
    
    func makeItemDetailPresentable(item: ItemList) -> ItemDetailPresentable {
        return itemDetailCntroller
    }
}
