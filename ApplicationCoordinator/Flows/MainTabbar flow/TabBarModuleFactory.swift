//
//  TabBarModuleFactory.swift
//  ApplicationCoordinator
//
//  Created by Dima Osadchy on 03/06/2019.
//  Copyright © 2019 Andrey Panov. All rights reserved.
//

protocol TabBarModuleFactory {
    func tabBarModule() -> TabbarPresentable
}
