// Playground - noun: a place where people can play

import UIKit

class Stack {
    
    var items = [AnyObject]()
    
    func push(item: AnyObject) {
        self.items.append(item)
    }
    
    func pop() -> AnyObject? {
        if !items.isEmpty {
            let item = self.items.last
            items.removeLast()
            return item
        } else {
            return nil
        }
    }
    
    func peek() -> AnyObject? {
        if !items.isEmpty {
            return self.items.last
        } else {
            return nil
        }
    }
    
    func size() -> Int {
        return items.count
    }
}

