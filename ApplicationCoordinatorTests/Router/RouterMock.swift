//
//  RouterMock.swift
//  ApplicationCoordinator
//
//  Created by Andrey on 02.09.16.
//  Copyright © 2016 Andrey Panov. All rights reserved.
//

import UIKit
@testable import ApplicationCoordinator

protocol RouterMockProtocol: RouterProtocol {
    var navigationStack: [UIViewController] {get}
    var presented: UIViewController? {get}
}

final class RouterMock: RouterMockProtocol {
    // in test cases router store the rootController referense
    private(set) var navigationStack: [UIViewController] = []
    private(set) var presented: UIViewController?
    private var completions: [UIViewController : () -> Void] = [:]
    
    var uiViewController: UIViewController? {
        return presented
    }
    
    //all of the actions without animation
    func present(_ module: Presentable?) {
        present(module, animated: false)
    }
    func present(_ module: Presentable?, animated: Bool) {
        guard let controller = module?.uiViewController else { return }
        presented = controller
    }
    
    func push(_ module: Presentable?)  {
        push(module, animated: true)
    }
    
    func push(_ module: Presentable?, hideBottomBar: Bool)  {
        push(module, animated: true, hideBottomBar: hideBottomBar, completion: nil)
    }
    
    func push(_ module: Presentable?, animated: Bool)  {
        push(module, animated: animated, completion: nil)
    }
    
    func push(_ module: Presentable?, animated: Bool, completion: CallbackClosure?) {
        push(module, animated: animated, hideBottomBar: false, completion: completion)
    }
    
    func push(_ module: Presentable?, animated: Bool, hideBottomBar: Bool, completion: CallbackClosure?) {
        guard
            let controller = module?.uiViewController,
            (controller is UINavigationController == false)
            else { assertionFailure("Deprecated push UINavigationController."); return }
        
        if let completion = completion {
            completions[controller] = completion
        }
        controller.hidesBottomBarWhenPushed = hideBottomBar
        navigationStack.append(controller)
    }
    
    func popModule()  {
        popModule(animated: false)
    }
    
    func popModule(animated: Bool)  {
        let controller = navigationStack.removeLast()
        runCompletion(for: controller)
    }
    
    func dismissModule() {
        dismissModule(animated: false, completion: nil)
    }
    
    func dismissModule(animated: Bool, completion: CallbackClosure?) {
        presented = nil
    }
    
    func setRootModule(_ module: Presentable?) {
        guard let controller = module?.uiViewController else { return }
        navigationStack.append(controller)
    }
    
    func setRootModule(_ module: Presentable?, hideBar: Bool) {
        assertionFailure("This method is not used.")
    }

    func popToRootModule(animated: Bool) {
        guard let first = navigationStack.first else { return }
        
        navigationStack.forEach { controller in
            runCompletion(for: controller)
        }
        navigationStack = [first]
    }
    
    private func runCompletion(for controller: UIViewController) {
        guard let completion = completions[controller] else { return }
        completion()
        completions.removeValue(forKey: controller)
    }
}
