//
//  ListElement.swift
//  LinkedListExample
//
//  Created by George Webster on 6/28/14.
//  Copyright (c) 2014 George Webster. All rights reserved.
//

import Foundation

class ListElement <T:NSObject> {
    
    var value: T? = nil
    var next: ListElement<T>? = nil
    var previous: ListElement<T>? = nil
    
    init () {
        
    }
    
    init( value: T ) {
        self.value = value
    }
    
}