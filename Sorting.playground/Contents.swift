//: Playground - noun: a place where people can play

import UIKit


/**
	Build Fibonacci sequence up to a certain limit
*/
func fibonacci(limit:Int) -> [Int] {
	
	if limit < 2 {
		return [Int]()
	}
	
	var penultimate = 0
	var ultimate = 1
	var sequence = [penultimate, ultimate]

	var next = penultimate + ultimate

	while (next <= limit) {
		sequence.append(next)
		
		penultimate = ultimate
		ultimate = next
		
		next = penultimate + ultimate
	}
	return sequence
}

var haystack = fibonacci(100000)

//
//func binarySearch(needle:Int, haystack:[Int]) {
//	
//	var lower = 0
//	var upper = haystack.count - 1
//	
//	var middle = (lower + upper) / 2
//	
//	if needle == middle {
//		return middle
//	} else if (needle <= middle) {
//		
//	} else {
//		
//	}
//}
