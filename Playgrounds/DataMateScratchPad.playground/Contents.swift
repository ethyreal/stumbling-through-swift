//: Playground - noun: a place where people can play

import UIKit


class Node<Element> {
    var item: Element
    
    var next:Node?
    
    init(item:Element) {
        
        self.item = item
    }
}




func fibonacci(limit:Int) -> Node<Int> {
    
    if limit < 2 {
        return Node<Int>(item: 1)
    }
    
    var penultimate = 0
    var ultimate = 1
    let first = Node<Int>(item: penultimate)
    var last = Node<Int>(item: ultimate)

    first.next = last
    
    var next = penultimate + ultimate
    
    while (next <= limit) {
        
        last.next = Node<Int>(item: next)

        guard let nextNode = last.next else {
            break
        }
        
        last = nextNode
        
        penultimate = ultimate
        ultimate = next
        
        next = penultimate + ultimate
    }
    
    return first
}

let fib = fibonacci(100)

var elm = fib

var hasNext = true

while (hasNext) {
    print("\(elm.item)")
    
    if let nextElm = elm.next {
      elm = nextElm
    } else {
        hasNext = false
    }
}


