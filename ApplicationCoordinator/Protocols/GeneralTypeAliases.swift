//
//  GeneralTypeAliases.swift
//  ApplicationCoordinator
//
//  Created by Dima Osadchy on 29/05/2019.
//  Copyright © 2019 Andrey Panov. All rights reserved.
//

import UIKit

/// General type declare
typealias Closure<T> = (T) -> Void
typealias ClosureReturn<T> = () -> T
typealias CallbackClosure = () -> Void
typealias Object = [String: Any]

/// Dialog typealias
typealias DialogContent = (title: String?, message: String?, icon: UIImage?, customView: UIView?)

typealias UnitComponents = (amount: String, unit: String)
