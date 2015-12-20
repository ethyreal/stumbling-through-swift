//: Playground - noun: a place where people can play

import UIKit

class Node<Element> {
    var item: Element
    
    var next:Node?
    
    init(item:Element) {
        
        self.item = item
    }
}

class Stack<Element> {
    
    var isEmpty:Bool {
        get {
            return (first == nil)
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
    
    func pop() -> Element? {
        guard let item = first else {
            return nil
        }
        
        first = item.next
        numberOfItems--
        
        return item.item
    }
    
    func peek() -> Element? {

        guard let item = first?.item else {
            return nil
        }
        
        return item
    }
}


var pigNames = Stack<String>()

pigNames.numberOfItems
pigNames.isEmpty

pigNames.push("Peppa")

pigNames.isEmpty
pigNames.numberOfItems

pigNames.push("George")

pigNames.numberOfItems

pigNames.push("Daddy Pig")

pigNames.numberOfItems

var name = pigNames.peek()

name = pigNames.pop()

pigNames.numberOfItems

name = pigNames.pop()

pigNames.numberOfItems

name = pigNames.pop()

pigNames.isEmpty
pigNames.numberOfItems
