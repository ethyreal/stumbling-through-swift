//
//  Stack.swift
//  DataMate
//
//  Created by George Webster on 12/17/15.
//  Copyright © 2015 George Webster. All rights reserved.
//

import Foundation


class Stack<Element> {

    var isEmpty:Bool {
        get {
            return (first != nil)
        }
    }

    var numberOfItems = 0
    
    private var first:Node<Element>?
    
    init() {
        
    }
    
    func push(item:Element) {
        
        let oldFirst = first
        
        let newFirst = Node<Element>(item: item)
        newFirst.next = oldFirst
        
        self.first = newFirst
        numberOfItems++
    }
    
    func pop() -> Node<Element>? {
        guard let item = first else {
            return nil
        }
        
        first = item.next
        numberOfItems--
        
        return item
    }
    
}