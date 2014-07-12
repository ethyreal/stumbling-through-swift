//
//  TileView.swift
//  DynamicLetterTiles
//
//  Created by George Webster on 7/10/14.
//  Copyright (c) 2014 George Webster. All rights reserved.
//

import UIKit

protocol TileViewDelegate {

    func tileViewDragToPoint( tileView:TileView, point:CGPoint )
    
    func tileViewStopDragging(tileView:TileView)
    
    func tileViewInsectsOutlineView( tileView:TileView ) -> ( intersects:Bool, outlineView:OutlineView? )

    func tileViewWillBeginPanning( tileView:TileView )
    func tileViewWillEndPanning( tileView:TileView )
    
    func tileViewWillSnapToOutlineView( tileView:TileView, outlineView:OutlineView )
}

class TileView: UIImageView {

    var delegate:TileViewDelegate
    var outlineView:OutlineView? = nil
    var character:NSString
    var characterLabel:UILabel
    
    init(imageName: NSString, delegate:TileViewDelegate, parentView:UIView) {
        self.delegate = delegate
        
        self.character = imageName
        
        let image = UIImage(named: "tile_blank")
        
        self.characterLabel = UILabel(frame: CGRectMake(0, 0, image.size.width, image.size.height))
        
        super.init(image: image)

        self.characterLabel.text = self.character
        self.characterLabel.textAlignment = NSTextAlignment.Center
        self.characterLabel.font = UIFont.systemFontOfSize(28.0)
        
        self.addSubview(self.characterLabel)
        
        let pan = UIPanGestureRecognizer(target: self, action: "handlePan:")
        
        self.addGestureRecognizer(pan)
        
    }

    func isInOutlineView() -> Bool {
        if self.outlineView {
            return true
        }
        
        return false
    }
    
    //panning
    
    func handlePan(pan: UIPanGestureRecognizer ) {
        
        self.delegate.tileViewWillBeginPanning(self)
        
        if pan.state == UIGestureRecognizerState.Began ||
           pan.state == UIGestureRecognizerState.Changed {
            
            var snapToPoint:CGPoint = pan.locationInView(self.superview)
            
            self.delegate.tileViewDragToPoint(self, point: snapToPoint)
            
        } else if pan.state == UIGestureRecognizerState.Ended ||
                  pan.state == UIGestureRecognizerState.Cancelled {
            
            self.delegate.tileViewWillEndPanning(self)
                    
            var intersection = self.delegate.tileViewInsectsOutlineView(self)
            
            if intersection.intersects {
                var snapToPoint:CGPoint = intersection.outlineView!.center
                
                self.delegate.tileViewWillSnapToOutlineView(self, outlineView: intersection.outlineView!)
                
                self.delegate.tileViewDragToPoint(self, point: snapToPoint)
            } else {
                self.delegate.tileViewStopDragging(self)
            }
                
                
        }
    }
    
    

}
