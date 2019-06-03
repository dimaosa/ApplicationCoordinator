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
    func present(_ presentable: Presentable?) {
        present(presentable, animated: false)
    }
    func present(_ presentable: Presentable?, animated: Bool) {
        guard let controller = presentable?.uiViewController else { return }
        presented = controller
    }
    
    func push(_ presentable: Presentable?)  {
        push(presentable, animated: true)
    }
    
    func push(_ presentable: Presentable?, hideBottomBar: Bool)  {
        push(presentable, animated: true, hideBottomBar: hideBottomBar, completion: nil)
    }
    
    func push(_ presentable: Presentable?, animated: Bool)  {
        push(presentable, animated: animated, completion: nil)
    }
    
    func push(_ presentable: Presentable?, animated: Bool, completion: CallbackClosure?) {
        push(presentable, animated: animated, hideBottomBar: false, completion: completion)
    }
    
    func push(_ presentable: Presentable?, animated: Bool, hideBottomBar: Bool, completion: CallbackClosure?) {
        guard
            let controller = presentable?.uiViewController,
            (controller is UINavigationController == false)
            else { assertionFailure("Deprecated push UINavigationController."); return }
        
        if let completion = completion {
            completions[controller] = completion
        }
        controller.hidesBottomBarWhenPushed = hideBottomBar
        navigationStack.append(controller)
    }
    
    func popPresentable()  {
        popPresentable(animated: false)
    }
    
    func popPresentable(animated: Bool)  {
        let controller = navigationStack.removeLast()
        runCompletion(for: controller)
    }
    
    func dismissPresentable() {
        dismissPresentable(animated: false, completion: nil)
    }
    
    func dismissPresentable(animated: Bool, completion: CallbackClosure?) {
        presented = nil
    }
    
    func setRootPresentable(_ presentable: Presentable?) {
        guard let controller = presentable?.uiViewController else { return }
        navigationStack.append(controller)
    }
    
    func setRootPresentable(_ presentable: Presentable?, hideBar: Bool) {
        assertionFailure("This method is not used.")
    }

    func popToRootPresentable(animated: Bool) {
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
