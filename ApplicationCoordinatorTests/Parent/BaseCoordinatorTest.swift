//
//  BaseCoordinatorTest.swift
//  ApplicationCoordinator
//
//  Created by Andrey on 04.09.16.
//  Copyright © 2016 Andrey Panov. All rights reserved.
//

import XCTest
@testable import ApplicationCoordinator

class BaseCoordinatorTest: XCTestCase {
    
    var coordinator: BaseCoordinator<EmptyAction>!

    override func setUp() {
        super.setUp()
        
        coordinator = BaseCoordinator()
    }
    
    override func tearDown() {
        coordinator = nil
        super.tearDown()
    }
    
    func testCoordinatorArrayInitializedOfEmptyArray() {
        XCTAssertTrue(coordinator.children.isEmpty)
    }
    
    func testCoordinatorAddDependency() {
        coordinator.addDependency(coordinator)
        XCTAssertTrue(coordinator.children.first is BaseCoordinator<EmptyAction>)
        XCTAssertTrue(coordinator.children.count == 1)
        coordinator.addDependency(coordinator)
        XCTAssertTrue(coordinator.children.count == 1, "Only unique reference could be added")
        
        let newCoordinator = BaseCoordinator<DismissAction>()
        coordinator.addDependency(newCoordinator)
        XCTAssertTrue(coordinator.children.count == 2)
    }
    
    func testCoordinatorRemoveDependency() {
        
        coordinator.addDependency(coordinator)
        XCTAssertTrue(coordinator.children.first is BaseCoordinator<EmptyAction>)
        coordinator.removeDependency(coordinator)
        XCTAssertTrue(coordinator.children.isEmpty)
        coordinator.removeDependency(coordinator)
        XCTAssertTrue(coordinator.children.isEmpty, "If we try to remove removed referense, crush can't happend")
    }
}
