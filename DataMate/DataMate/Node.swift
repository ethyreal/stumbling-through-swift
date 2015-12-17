//
//  Node.swift
//  DataMate
//
//  Created by George Webster on 12/17/15.
//  Copyright © 2015 George Webster. All rights reserved.
//

import Foundation

class Node<Element> {
    var item: Element
    
    var next:Node?
    
    init(item:Element) {
        
        self.item = item
    }
}
