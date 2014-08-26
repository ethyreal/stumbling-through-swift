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
    
    func tileViewFrameInsectsOutlineView( frame:CGRect ) -> ( intersects:Bool, outlineView:OutlineView? )

    func tileViewWillBeginPanning( tileView:TileView )
    func tileViewWillEndPanning( tileView:TileView )
    
    func tileViewWillSnapToOutlineView( tileView:TileView, outlineView:OutlineView )
    func tileViewDidSnapToOutlineView( tileView:TileView, outlineView:OutlineView )
}

class TileView: UIImageView {

    var delegate:TileViewDelegate?
    var outlineView:OutlineView? = nil
    var character:NSString
    var characterLabel:UILabel?
    
    required init(coder aDecoder: NSCoder!) {
        self.character = ""
        super.init(coder: aDecoder);
    }
    
    init(imageName: NSString, delegate:TileViewDelegate, parentView:UIView) {
        self.delegate = delegate
        
        self.character = imageName
        
        let image = UIImage(named: "tile_blank")
        
        self.characterLabel = UILabel(frame: CGRectMake(0, 0, image.size.width, image.size.height))
        
        super.init(image: image)

        if let chLabel = self.characterLabel {
            chLabel.text = self.character
            chLabel.textAlignment = NSTextAlignment.Center
            chLabel.font = UIFont.systemFontOfSize(30.0)

            self.addSubview(chLabel)
        }
        
        let pan = UIPanGestureRecognizer(target: self, action: "handlePan:")
        
        self.addGestureRecognizer(pan)
        
    }

    func isInOutlineView() -> Bool {
        if (self.outlineView != nil) {
            return true
        }
        
        return false
    }
    
    //panning
    
    func handlePan(pan: UIPanGestureRecognizer ) {
        
        self.delegate?.tileViewWillBeginPanning(self)
        
        var snapToPoint:CGPoint = pan.locationInView(self.superview)
        
        if pan.state == UIGestureRecognizerState.Began ||
           pan.state == UIGestureRecognizerState.Changed {
            
            self.delegate?.tileViewDragToPoint(self, point: snapToPoint)
            
        } else if pan.state == UIGestureRecognizerState.Ended ||
                  pan.state == UIGestureRecognizerState.Cancelled {
            
            self.delegate?.tileViewWillEndPanning(self)
                    
            var newTileFrame = self.rectForCenterPoint(snapToPoint)
                    
            var hasIntersetion = self.delegate?.tileViewFrameInsectsOutlineView(newTileFrame)
            
            if let intersection = hasIntersetion {
                
                if let ov = intersection.outlineView {
                    snapToPoint = ov.center
                    
                    self.delegate?.tileViewWillSnapToOutlineView(self, outlineView: ov)
                    
                    self.delegate?.tileViewDragToPoint(self, point: snapToPoint)
                    
                    self.delegate?.tileViewDidSnapToOutlineView(self, outlineView: ov)

                }
                
                
            } else {
                self.delegate?.tileViewStopDragging(self)
            }
                
                
        }
    }
    
    func rectForCenterPoint(point:CGPoint) -> CGRect {
        var rect = CGRectZero
        rect.size = self.frame.size
        
        rect.origin.x = point.x - CGRectGetMidX(rect)
        rect.origin.y = point.y - CGRectGetMidY(rect)
        
        return rect
    }

}
