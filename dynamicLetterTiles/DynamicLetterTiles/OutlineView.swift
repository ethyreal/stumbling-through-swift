//
//  OutlineView.swift
//  DynamicLetterTiles
//
//  Created by George Webster on 7/7/14.
//  Copyright (c) 2014 George Webster. All rights reserved.
//

import UIKit

class OutlineView: UIView {

    let dashedBorderWidth:CGFloat = 2.0
    let dashedPhase:CGFloat = 0.0
    //let dashedLinesLength:ConstUnsafePointer<CGFloat> = [4.0, 2.0]
    let dashedCount:size_t = 2
    var tileView:TileView? = nil
    let boundryIdentifier:NSString
    
    init(frame: CGRect, boundryIdentifier:NSString) {
        self.boundryIdentifier = boundryIdentifier
        super.init(frame: frame)
    }
    
    func constainsTileView() -> Bool {
        if self.tileView {
            return true
        }
        
        return false
    }

    override func drawRect(rect: CGRect)
    {
        
        var context:CGContextRef = UIGraphicsGetCurrentContext()

        UIColor.whiteColor().set()
        
        CGContextStrokeRect(context, rect)
        CGContextFillRect(context, rect)
        
        CGContextSetLineWidth(context, dashedBorderWidth)
        CGContextSetStrokeColorWithColor(context, UIColor.lightGrayColor().CGColor)
        CGContextSetLineDash(context, dashedPhase, [4.0, 2.0], dashedCount)
        
        let insetRect = CGRectInset(rect, 3, 3)
        
        CGContextAddRect(context, insetRect)
        
        CGContextStrokePath(context)
    }

    
}
