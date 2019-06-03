//
//  Atomic.swift
//  ApplicationCoordinator
//
//  Created by Dima Osadchy on 03/06/2019.
//  Copyright © 2019 Andrey Panov. All rights reserved.
//

final class Atomic<A> {
    private let queue = DispatchQueue(label: "Atomic Serial Queue")
    private var _value: A
    
    init(_ value: A) {
        _value = value
    }
    
    var value: A {
        get {
            return queue.sync{ self._value }
        }
    }
    
    func mutate(_ transform: (inout A) -> ()) {
        queue.sync {
            transform(&self._value)
        }
    }
}
