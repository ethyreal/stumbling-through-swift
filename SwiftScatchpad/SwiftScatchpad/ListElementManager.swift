//
//  ListElementManager.swift
//  LinkedListExample
//
//  Created by George Webster on 6/28/14.
//  Copyright (c) 2014 George Webster. All rights reserved.
//

import Foundation

class ListElementManager<T:NSObject> {
    
    var firstElement: ListElement<T> = ListElement<T>()
    var lastElelment: ListElement<T> = ListElement<T>()
    
    var numberOfElements: Int = 0
    
    init() {
        
    }
    
    func isEmpty() -> Bool {
        return self.numberOfElements == 0;
    }
    
    func addElement( value: T ) {
        var element = ListElement<T>( value: value )
        
        if self.isEmpty() {
            self.firstElement = element;
            self.lastElelment = element;
        } else {
            element.previous = self.lastElelment;
            self.lastElelment = element;
        }
        self.numberOfElements++
    }
    
    func prependElement( value: T ) {
        
        if self.isEmpty() {
            self.addElement( value )
        } else {
            var element = ListElement( value: value )
            
            element.next = self.firstElement;
            
            self.firstElement.previous = element;
            
            self.firstElement = element;
            
            self.numberOfElements++
        }
    }
    
    func removeElement ( value: T ) {
        
        if let element = self.findElement( value ) {
            
            // assumed safe if find returns value
            var firstValue  = self.firstElement.value!
            var lastValue   = self.lastElelment.value!
            
            switch value {
                
                case firstValue:
                    if let next: ListElement<T> = element.next {
                        next.previous = nil
                        self.firstElement = next
                        
                        self.numberOfElements--
                    }
                case lastValue:
                    if let previous: ListElement<T> = element.previous {
                        previous.next = nil
                        self.lastElelment = previous
                        
                        self.numberOfElements--
                    }
                
                default:
                
                    if let nextElm: ListElement<T> = element.next {
                        
                         if let prevElm:ListElement<T> = element.previous {
                            
                            prevElm.next = nextElm;
                            nextElm.previous = prevElm;
                            
                            self.numberOfElements--
                        }
                    
                    }
            }
        }
    }
    
    func findElement ( value: T ) -> ListElement<T>?  {
        var foundElement: ListElement<T>? = nil
        
        var element: ListElement<T> = self.firstElement;
        
        if element.value {
            var foundValue: T = element.value!
            
            while ( element.next && foundValue != value ) {

                element = element.next!
                
                if element.value {
                    foundValue = element.value!
                }
            }
            
            if foundValue == value {
                foundElement = element
            }
        }
        
        return foundElement;
    }
    
}
