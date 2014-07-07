//
//  SimpleCoreTextView.swift
//  SwiftScatchpad
//
//  Created by George Webster on 6/25/14.
//  Copyright (c) 2014 George Webster. All rights reserved.
//

/*
    Since Swift is iOS 7+ it is not likely manipulting CoreText directly is needed given TextKit.core
    
    It could still be neessisary, plus I want to play with some C api's in Swift.swift
*/

import UIKit
import CoreText

class SimpleCoreTextView: UIView {

    var attrString : NSMutableAttributedString? = nil
    var ctFrame: CTFrameRef? = nil
    
    init(frame: CGRect, text:NSString) {
        
        self.attrString = NSMutableAttributedString(string: text)
        
        super.init(frame: frame)
        
        self.sharedInit()
    }
    
    init(coder aDecoder: NSCoder!) {
        
        super.init(coder: aDecoder)
        
        self.sharedInit()
    }
    
    func sharedInit() {
        self.backgroundColor = UIColor.clearColor()
        
        // filp transform for core text
        
        var transform : CGAffineTransform = CGAffineTransformMakeScale(1, -1)
        
        CGAffineTransformTranslate(transform, 0, -CGRectGetHeight(self.bounds))
        
        self.transform = transform
    }
    

    override func drawRect(rect: CGRect)
    {
        if self.attrString {
            let context = UIGraphicsGetCurrentContext()
            
            CGContextSaveGState(context);
            
            CGContextSetTextMatrix(context, CGAffineTransformIdentity)
            
            var path : CGMutablePathRef = CGPathCreateMutable()
            
            CGPathAddRect(path, nil, self.bounds)
            
            let framesetter : CTFramesetterRef = CTFramesetterCreateWithAttributedString(self.attrString)
            
            let textLength = self.attrString!.length
            
            self.ctFrame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, self.attrString!.length), path, nil)
            
            if self.ctFrame {
                CTFrameDraw(self.ctFrame!, context)
            }
            
            CGContextRestoreGState(context);

            drawHighlights()
        }
    }

    func drawHighlights() {
        
    }
    
}
