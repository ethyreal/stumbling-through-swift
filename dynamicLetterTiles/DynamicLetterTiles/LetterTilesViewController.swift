//
//  LetterTilesViewController.swift
//  SwiftScatchpad
//
//  Created by George Webster on 7/6/14.
//  Copyright (c) 2014 George Webster. All rights reserved.
//

import UIKit

class LetterTilesViewController: UIViewController, UIGestureRecognizerDelegate, UIDynamicAnimatorDelegate {

    var characters:NSString? = nil {
        didSet {
            if self.characters {
                self.loadDataString()
            }
        }
    }
    var charactersNoWhiteSpace:NSString? = nil
    
    var tileViews:NSMutableArray? = nil
    var targetOutlineViews:NSMutableArray? = nil
    
    var animator:UIDynamicAnimator? = nil
    
    var currentBehavior:UISnapBehavior? = nil
    var currentTile:UIImageView? = nil
    
    init(coder aDecoder: NSCoder!) {
        
        
        super.init(coder: aDecoder)
    }
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.animator = UIDynamicAnimator(referenceView: self.view)
        self.animator!.delegate = self
        
        setupTiles()
        setupTargets()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func loadDataString() {
        if self.characters {
            
            let upperCaseCharacters:NSString = self.characters!.uppercaseString
            self.charactersNoWhiteSpace = upperCaseCharacters.stringByTrimmingCharactersInSet( NSCharacterSet.whitespaceAndNewlineCharacterSet() )
            
            if self.charactersNoWhiteSpace {
                self.tileViews = NSMutableArray(capacity: self.charactersNoWhiteSpace!.length)
                self.targetOutlineViews = NSMutableArray(capacity: self.charactersNoWhiteSpace!.length)
            }
        }
    }
    
    func setupTiles() {
        
        if self.charactersNoWhiteSpace {
            
            let startX:CGFloat = 10.0
            let startY:CGFloat = CGRectGetMidY(self.view.bounds)
            
            let bufferX:CGFloat = 5.0
            let bufferY:CGFloat = 5.0
            
            var currentX = startX
            var currentY = startY
            
            let enumerationOptions: NSStringEnumerationOptions = .ByComposedCharacterSequences
            
            let range: NSRange = NSMakeRange(0, self.charactersNoWhiteSpace!.length)
            
            self.charactersNoWhiteSpace!.enumerateSubstringsInRange( range, options: enumerationOptions ) { character, _, _, stop in
                
                let tileImage   = UIImage(named: character)
                let tileView    = UIImageView(image: tileImage)
                
                tileView.userInteractionEnabled = true
                tileView.layer.zPosition = 20
                
                var tileFrame = tileView.frame
                
                tileFrame.origin.x = currentX
                tileFrame.origin.y = currentY
                
                tileView.frame = tileFrame

                let pan = UIPanGestureRecognizer(target: self, action: "handlePan:")
                
                tileView.addGestureRecognizer(pan)
                
                self.view.addSubview(tileView)
                
                if self.tileViews {
                    self.tileViews!.addObject(tileView)
                }
                
                currentX += CGRectGetWidth(tileFrame) + bufferX
                
                if currentX + CGRectGetWidth(tileFrame) > CGRectGetWidth(self.view.bounds) {
                    currentX = startX
                    currentY = CGRectGetMaxY(tileFrame) + bufferY
                }
                
            }
            
            
        }
        
        
    }
    
    func setupTargets() {
        
        if self.tileViews {
            
            let startX:CGFloat = 10.0
            let startY:CGFloat = self.topLayoutGuide.length + 10
            
            let bufferX:CGFloat = 5.0
            let bufferY:CGFloat = 5.0
            
            var currentX = startX
            var currentY = startY
            
            for obj:AnyObject in self.tileViews! {
                
                let iv = obj as UIImageView
                
                var outlineFrame = CGRectInset( iv.frame, -6, -6)
                let outlineView = OutlineView( frame: outlineFrame )
                
                outlineView.layer.zPosition = 10
                
                outlineFrame.origin.x = currentX
                outlineFrame.origin.y = currentY
                
                outlineView.frame = outlineFrame
                
                self.view.addSubview(outlineView)
                
                self.targetOutlineViews!.addObject(outlineView)
                
                currentX += CGRectGetWidth(outlineFrame) + bufferX
                
                if currentX + CGRectGetWidth(outlineFrame) > CGRectGetWidth(self.view.bounds) {
                    currentX = startX
                    currentY = CGRectGetMaxY(outlineFrame) + bufferY
                }
            }
        }
    }
    
    func handlePan(pan: UIPanGestureRecognizer ) {
        
        let tileView = pan.view as UIImageView
        self.currentTile = tileView
        
        if pan.state == UIGestureRecognizerState.Began {
            
            if self.animator {
                self.animator!.removeAllBehaviors()
        
            }
            
        } else if pan.state == UIGestureRecognizerState.Changed {
            
            var newCenter:CGPoint = tileView.center
            
            newCenter.x += pan.translationInView(self.view).x
            newCenter.y += pan.translationInView(self.view).y
            
            tileView.center = newCenter
            
            pan.setTranslation(CGPointZero, inView: self.view)
            
        } else if pan.state == UIGestureRecognizerState.Ended {
            
            if self.animator {
                self.animator!.removeAllBehaviors()
                
                
                var intersection = tileViewInsectsOutlineView(tileView)
                
                if intersection.intersects {
                    var snapToPoint:CGPoint = intersection.outlineView!.center
                    self.currentBehavior = UISnapBehavior(item: tileView, snapToPoint: snapToPoint)
                    
                    self.animator!.addBehavior(self.currentBehavior!)
                }
                
                
            }
        }
    }
    
    func tileViewInsectsOutlineView( tileView:UIView ) -> ( intersects:Bool, outlineView:OutlineView? ) {
        
        var intersects:Bool = false
        var outlineView:OutlineView? = nil
        
        if self.targetOutlineViews {
            for obj:AnyObject in self.targetOutlineViews! {
                let ov = obj as OutlineView
                
                if CGRectIntersectsRect(tileView.frame, ov.frame) {
                    intersects = true
                    outlineView = ov
                    break
                }
            }
        }
        
        return (intersects, outlineView)
    }
    
    // UIDynamicAnimatorDelegate
    
    func dynamicAnimatorDidPause(animator: UIDynamicAnimator!) {
        if self.currentBehavior {
            animator.removeBehavior(self.currentBehavior!)
        }
    }

}
