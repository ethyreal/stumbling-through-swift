//
//  ARStack.swift
//  DataMate
//
//  Created by George Webster on 12/18/15.
//  Copyright © 2015 George Webster. All rights reserved.
//

import Foundation


class ARStack<Element> {
    
    var isEmpty:Bool {
        get {
            return data.isEmpty
        }
    }
    
    var numberOfItems:Int {
        get {
            return data.count
        }
    }
    
    private var data = [Element]()
    
    init() {
        
    }
    
    func push(item:Element) {
        
        data.append(item)
    }
    
    func pop() -> Element? {

        if data.count > 0 {
            return data.removeLast()
        }
        
        return nil
    }
    
}