//
//  TileView.swift
//  DynamicLetterTiles
//
//  Created by George Webster on 7/10/14.
//  Copyright (c) 2014 George Webster. All rights reserved.
//

import UIKit

protocol TileViewDelegate {

    func tileViewInsectsOutlineView( tileView:TileView ) -> ( intersects:Bool, outlineView:OutlineView? )

    func tileViewWillBeginPanning( tileView:TileView )
    
    func tileViewWillSnapToOutlineView( tileView:TileView, outlineView:OutlineView )
}

class TileView: UIImageView, UIDynamicAnimatorDelegate {

    var delegate:TileViewDelegate
    var animator:UIDynamicAnimator
    var currentBehavior:UISnapBehavior? = nil
    var outlineView:OutlineView? = nil
    var character:NSString
    
    init(imageName: NSString, delegate:TileViewDelegate, parentView:UIView) {
        self.delegate = delegate
        self.animator = UIDynamicAnimator(referenceView: parentView)
        
        self.character = imageName
        
        let image = UIImage(named: self.character)
        
        super.init(image: image)

        self.animator.delegate = self
        
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
            
            self.dragToPoint(snapToPoint)
            
        } else if pan.state == UIGestureRecognizerState.Ended ||
                  pan.state == UIGestureRecognizerState.Cancelled {
            
            self.animator.removeAllBehaviors()
            
            var intersection = self.delegate.tileViewInsectsOutlineView(self)
            
            if intersection.intersects {
                var snapToPoint:CGPoint = intersection.outlineView!.center
                
                self.delegate.tileViewWillSnapToOutlineView(self, outlineView: intersection.outlineView!)
                
                self.dragToPoint(snapToPoint)
            } else {
                self.stopDragging()
            }
                
                
        }
    }
    
    func dragToPoint( point:CGPoint ) {
        self.stopDragging()
        self.currentBehavior = UISnapBehavior(item: self, snapToPoint: point)
        self.currentBehavior!.damping = 0.25
        self.animator.addBehavior(self.currentBehavior!)
    }
    
    func stopDragging() {
        if self.currentBehavior {
            self.animator.removeBehavior(self.currentBehavior!)
            self.currentBehavior = nil
        }
    }
    
    // UIDynamicAnimatorDelegate
    
    func dynamicAnimatorDidPause(animator: UIDynamicAnimator!) {
        if self.currentBehavior {
            animator.removeBehavior(self.currentBehavior!)
        }
        // because the outline view we maybe snaped to is behind all the views
        // in order to grab it again we have to make sure it is back in the front
        // or we could do some pass through logic but this is simpler for now
        self.superview.bringSubviewToFront(self)
    }


}
