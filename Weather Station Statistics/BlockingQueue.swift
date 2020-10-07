//
//  BlockingQueue.swift
//  Weather Station Statistics
//
//  Created by Yuval Weinstein on 11/07/2020.
//  Copyright © 2020 Yuval Weinstein. All rights reserved.
//

import Foundation

class BlockingQueue<T> {
    
    private var container = Array<T>()
    private let availablitySemaphore = DispatchSemaphore(value: 0)
    private let queue = DispatchQueue(label: "BlockingQueue")
    
    func push(_ item: T) {
        self.queue.async {
            self.container.insert(item, at: 0)
            self.availablitySemaphore.signal()
        }
    }
    
    func push(_ items: [T]) {
        for item in items {
            self.push(item)
        }
    }
    
    func pop() -> T {
        self.availablitySemaphore.wait()
        return self.container.popLast()!
    }
    
    var count: Int {
        return container.count
    }
}
