//: Playground - noun: a place where people can play

import UIKit

// How would you reverse a string?  In Swift

var str = "Hello, playground"

var reversedStr = ""
for char in str.characters {
    reversedStr.insert(char, atIndex: reversedStr.characters.startIndex)
}
print(reversedStr)

// How would you reverse an NSSring?

var another:NSString = str as NSString

var reversedNS = NSMutableString(capacity: another.length)

var idx = another.length

while (idx > 0) {
    idx--
    let range = NSMakeRange(idx, 1)
    let char = another.substringWithRange(range)
    reversedNS.appendString(char)
}
print(reversedNS)


// or

reversedNS = NSMutableString(capacity: another.length)

let range = NSMakeRange(0, another.length)
let options:NSStringEnumerationOptions = [.Reverse, .ByComposedCharacterSequences]
another.enumerateSubstringsInRange(range, options: options) { (substring, substringRange, enclosingRange, stop) -> Void in
    if let str = substring {
        reversedNS.appendString(str)
    }
}
print(reversedNS)
