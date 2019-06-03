//
//  RouterTest.swift
//  ApplicationCoordinator
//
//  Created by Andrey on 02.09.16.
//  Copyright © 2016 Andrey Panov. All rights reserved.
//

import XCTest
@testable import ApplicationCoordinator

class RouterTest: XCTestCase {
    
    private var router: RouterMockProtocol!
    
    private var firstController: UIViewController!
    private var secondController: UIViewController!
    private var thirdController: UIViewController!
    
    override func setUp() {
        super.setUp()
        
        router = RouterMock()
        firstController = ItemsListController.controllerFromStoryboard(.items)
        secondController = ItemDetailController.controllerFromStoryboard(.items)
        thirdController = SettingsController.controllerFromStoryboard(.settings)
    }
    
    override func tearDown() {
        
        router = nil
        firstController = nil
        secondController = nil
        thirdController = nil
        
        super.tearDown()
    }
    
    func testRouterSetRootPresentable() {
        
        router.setRootPresentable(firstController)
        XCTAssertTrue(router.navigationStack.first is ItemsListController)
    }
    
    func testRouterPushViewPresentable() {
        
        router.setRootPresentable(firstController)
        XCTAssertTrue(router.navigationStack.last is ItemsListController)
        router.push(secondController)
        XCTAssertTrue(router.navigationStack.last is ItemDetailController)
    }
    
    func testRouterPopViewPresentable() {
        
        router.setRootPresentable(firstController)
        XCTAssertTrue(router.navigationStack.last is ItemsListController)
        router.push(secondController)
        XCTAssertTrue(router.navigationStack.last is ItemDetailController)
        
        router.popPresentable()
        XCTAssertTrue(router.navigationStack.last is ItemsListController)
    }
    
    func testRouterPopToRootViewPresentable() {
        
        router.setRootPresentable(firstController)
        XCTAssertTrue(router.navigationStack.last is ItemsListController)
        router.push(secondController)
        XCTAssertTrue(router.navigationStack.last is ItemDetailController)
        router.push(thirdController)
        XCTAssertTrue(router.navigationStack.last is SettingsController)
        
        router.popToRootPresentable(animated: false)
        XCTAssertTrue(router.navigationStack.last is ItemsListController)
    }
    
    func testPresentViewPresentable() {
        router.present(secondController)
        XCTAssertTrue(router.presented is ItemDetailController)
    }
    
    func testDismissViewPresentable() {
        
        router.present(secondController)
        XCTAssertTrue(router.presented is ItemDetailController)
        router.dismissPresentable()
        XCTAssertTrue(router.presented == nil)
    }
}
