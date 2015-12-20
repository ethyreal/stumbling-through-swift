//: Playground - noun: a place where people can play

import UIKit


class Node<Element> : CustomStringConvertible {
    var item: Element
    
    var next:Node?
    
    var description:String {
        return "\(self.dynamicType) item:\(self.item)"
    }
    
    init(item:Element) {
        
        self.item = item
    }
}

class Queue<Element> : CustomStringConvertible {
    
    var isEmpty:Bool {
        get {
            return (first == nil)
        }
    }
    
    var numberOfItems = 0

    var description:String {
        return "\(self.dynamicType) count:\(self.numberOfItems) first:\(self.first) last:\(self.last)"
    }
    
    private var first:Node<Element>?
    private var last:Node<Element>?
    
    func enqueue(item:Element) {
        
        let itemToEnqueue = Node<Element>(item: item)
        
        if let last = self.last {
            last.next = itemToEnqueue
        }
        
        self.last = itemToEnqueue
        
        if self.first == nil {
            self.first = self.last
        }
        
        numberOfItems++
    }
    
    func dequeue() -> Element? {
        
        guard let itemToDequeue = first else {
            return nil
        }

        first = first?.next
        
        if first == nil {
            last = nil
        }

        numberOfItems--
        
        return itemToDequeue.item
    }
    
    func peak() -> Element? {
        
        guard let item = first?.item else {
            return nil
        }
        
        return item
    }
}


var pigQueue = Queue<String>()

pigQueue.isEmpty
pigQueue.numberOfItems

pigQueue.enqueue("Peppa")

pigQueue.isEmpty
pigQueue.numberOfItems

pigQueue.dequeue()
pigQueue.dequeue()

pigQueue.enqueue("Peppa")
pigQueue.enqueue("George")
pigQueue.enqueue("Daddy Pig")
pigQueue.enqueue("Mummy Pig")

pigQueue.peak()
pigQueue.dequeue()
pigQueue.numberOfItems

pigQueue.dequeue()



