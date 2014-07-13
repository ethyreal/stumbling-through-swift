//
//  LetterTilesViewController.swift
//  SwiftScatchpad
//
//  Created by George Webster on 7/6/14.
//  Copyright (c) 2014 George Webster. All rights reserved.
//

import UIKit

class LetterTilesViewController: UIViewController, TileViewDelegate, UIDynamicAnimatorDelegate, UICollisionBehaviorDelegate, UIAlertViewDelegate {

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
    
    var currentTile:TileView? = nil
    
    var animator:UIDynamicAnimator? = nil
    var collision:UICollisionBehavior? = nil
    var currentSnapBehavior:UISnapBehavior? = nil
    var tileProperties:UIDynamicItemBehavior? = nil
    
    init(coder aDecoder: NSCoder!) {
        
        
        super.init(coder: aDecoder)
    }
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.animator = UIDynamicAnimator(referenceView: self.view)
        
    }

    override func viewWillAppear(animated: Bool) {
        setupTiles()
        setupTargets()
        setupCollisions()
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
        
        if self.charactersNoWhiteSpace && self.tileViews {

            let enumerationOptions: NSStringEnumerationOptions = .ByComposedCharacterSequences
            
            let range: NSRange = NSMakeRange(0, self.charactersNoWhiteSpace!.length)

            // setup tileViews
            self.charactersNoWhiteSpace!.enumerateSubstringsInRange( range, options: enumerationOptions ) { character, _, _, stop in
                
                let tileView    = TileView(imageName: character, delegate: self, parentView: self.view)
                
                tileView.userInteractionEnabled = true
                tileView.layer.zPosition = 20
                
                self.tileViews!.addObject(tileView)
                
            }
            
            //randomize
            let randmizedTiles = self.randomizedArray(self.tileViews!)
            self.tileViews = NSMutableArray(array: randmizedTiles)
            
            let bufferX:CGFloat = 5.0
            let bufferY:CGFloat = 5.0

            let charCount:CGFloat = CGFloat(self.charactersNoWhiteSpace!.length)

            let tv = self.tileViews!.lastObject as TileView
            
            let tileTotalWidth:CGFloat = (charCount * CGRectGetWidth(tv.frame)) + (charCount * bufferX ) - bufferX // doesn't count foriegn charactes!
            let startX:CGFloat = CGRectGetMidX(self.view.bounds) - ( tileTotalWidth / 2 )
            let startY:CGFloat = CGRectGetMidY(self.view.bounds)
            
            var currentX = startX
            var currentY = startY
            
            for obj:AnyObject in self.tileViews! {
                let tileView = obj as TileView
                var tileFrame = tileView.frame
                
                tileFrame.origin.x = currentX
                tileFrame.origin.y = currentY
                
                tileView.frame = tileFrame
                
                self.view.addSubview(tileView)
                
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
            
            let bufferX:CGFloat = 5.0
            let bufferY:CGFloat = 5.0
            
            let charCount:CGFloat = CGFloat(self.charactersNoWhiteSpace!.length)
            
            let tv = self.tileViews!.lastObject as TileView
            
            var outlineFrame = CGRectInset( tv.frame, -6, -6)
            
            let tileTotalWidth = (charCount * CGRectGetWidth(outlineFrame)) + (charCount * bufferX ) - bufferX // doesn't count foriegn charactes!
            let startX:CGFloat = CGRectGetMidX(self.view.bounds) - ( tileTotalWidth / 2 )
            
            let startY:CGFloat = self.topLayoutGuide.length + ( CGRectGetHeight(self.view.bounds) / 4 )
            
            var currentX = startX
            var currentY = startY
            
            var index = 0
            
            for obj:AnyObject in self.tileViews! {
                
                let identifier = "outlineBoundry\(index)"
                let outlineView = OutlineView( frame: outlineFrame, boundryIdentifier:identifier )
                
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
                
                index++
            }
        }
    }
    
    func setupCollisions() {
        
        self.collision = nil
        
        if self.tileViews {
            var colArray = NSMutableArray(capacity: self.tileViews!.count)

            self.collision = UICollisionBehavior(items: self.tileViews)
            self.collision!.translatesReferenceBoundsIntoBoundary = true
            self.collision!.collisionDelegate = self
            //self.collision!.collisionMode = UICollisionBehaviorMode.Boundaries
            
            self.tileProperties = UIDynamicItemBehavior(items: self.tileViews)
            self.tileProperties!.friction = 1
            self.tileProperties!.resistance = 1
            self.tileProperties!.angularResistance = 1
            self.tileProperties!.elasticity = 0.25
            self.tileProperties!.allowsRotation = false
            
            if self.animator {
                self.animator!.addBehavior(self.tileProperties!)
                self.animator!.addBehavior(self.collision!)
            }
        }
    }

    // actions
    
    @IBAction func handleCheck(sender:UIBarButtonItem) {
        
        if self.targetOutlineViews {
            //var stringToCheck:NSMutableString = NSMutableString()
            var stringToCheck:String = ""
            
            for obj:AnyObject in self.targetOutlineViews! {
                var outline = obj as OutlineView
                
                if outline.tileView {
                    stringToCheck = stringToCheck + outline.tileView!.character
                }
            }
            
            var alert:UIAlertView
            var title:NSString = NSString(string: " ")
            var message:NSString
            var cancelButtonTitle:NSString = NSString(string: "Ok")
            
            if stringToCheck.bridgeToObjectiveC().isEqualToString(self.charactersNoWhiteSpace) {
                message = NSString(string: "Correct!")
            } else {
                message = NSString(string: "Try again")
            }
            alert = UIAlertView(title: title, message: message, delegate: self, cancelButtonTitle: cancelButtonTitle)

            alert.show()
        }
    }
    
    @IBAction func handleReset(sender:UIBarButtonItem) {
        
        if self.animator {
            self.animator!.removeAllBehaviors()
        }
        
        if self.targetOutlineViews {
            for obj:AnyObject in self.targetOutlineViews! {
                let ov = obj as OutlineView
                
                ov.tileView = nil
            }
        }
        
        if self.tileViews {
            
            for obj:AnyObject in self.tileViews! {
                let tv = obj as TileView
                
                tv.removeFromSuperview()
            }
            
            self.tileViews!.removeAllObjects()
            
            setupTiles()
            setupCollisions()
        }
    }
    
    // TileViewDelegate
    
    func tileViewDragToPoint( tileView:TileView, point:CGPoint ) {
        if self.animator {
            self.tileViewStopDragging(tileView)
            self.currentSnapBehavior = UISnapBehavior(item: tileView, snapToPoint: point)
            self.currentSnapBehavior!.damping = 0.25
            self.animator!.addBehavior(self.currentSnapBehavior!)
            
            // because the outline view we maybe snaped to is behind all the views
            // in order to grab it again we have to make sure it is back in the front
            // or we could do some pass through logic but this is simpler for now
            
            self.view.bringSubviewToFront(tileView)
        }
    }
    
    func tileViewStopDragging(tileView:TileView) {
        self.removeCurrentSnapBehavior()
    }

    func tileViewWillBeginPanning( tileView:TileView ) {
        self.currentTile = tileView
        
        if tileView.outlineView {
            
            if self.collision {
                self.collision!.removeBoundaryWithIdentifier(tileView.outlineView!.boundryIdentifier)
            }
            if tileView.outlineView!.tileView {
                tileView.outlineView!.tileView = nil
            }
            tileView.outlineView = nil
        }
    }
    
    func tileViewWillEndPanning( tileView:TileView ) {
        self.removeCurrentSnapBehavior()
    }
    
    func removeCurrentSnapBehavior() {
        if self.currentSnapBehavior && self.animator {
            self.animator!.removeBehavior(self.currentSnapBehavior!)
            self.currentSnapBehavior = nil
        }
    }

    func tileViewWillSnapToOutlineView( tileView:TileView, outlineView:OutlineView ) {
        tileView.outlineView = outlineView
        outlineView.tileView = tileView
        
    }
    
    func tileViewDidSnapToOutlineView( tileView:TileView, outlineView:OutlineView ) {
        if self.collision {
            let path = UIBezierPath(rect: outlineView.frame)
            self.collision!.addBoundaryWithIdentifier(outlineView.boundryIdentifier, forPath: path)
        }
    }

    
    func tileViewInsectsOutlineView( tileView:TileView ) -> ( intersects:Bool, outlineView:OutlineView? ) {
        
        var intersects:Bool = false
        var outlineView:OutlineView? = nil
        
        if self.targetOutlineViews {
            for obj:AnyObject in self.targetOutlineViews! {
                let ov = obj as OutlineView
                
                // todo add collision detectoin, but for now just dont allow overlap
                if CGRectIntersectsRect(tileView.frame, ov.frame) && !ov.tileView {
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
    }
    
    // UICollisionBehaviorDelegate
    
    func collisionBehavior(behavior: UICollisionBehavior!,
        beganContactForItem item1: UIDynamicItem!,
        withItem item2: UIDynamicItem!,
        atPoint p: CGPoint) {
            
            let tile1 = item1 as TileView
            let tile2 = item2 as TileView
            
            println("\(tile1.character) tile began contact with \(tile2.character) tile")
            
    }
    
    func collisionBehavior(behavior: UICollisionBehavior!,
        endedContactForItem item1: UIDynamicItem!,
        withItem item2: UIDynamicItem!) {

            let tile1 = item1 as TileView
            let tile2 = item2 as TileView
            
            println("\(tile1.character) tile ended contact with \(tile2.character) tile")
    }
    
    // UIAlertView Delegate
    
    func alertView( alertView: UIAlertView!, clickedButtonAtIndex buttonIndex: Int) {
            
    }
    
    // helprs - TODO make this an extention
    
    func randomizedArray( source:NSArray ) -> NSArray {
        var shuffled = NSMutableArray(capacity: source.count)
        
        var copy = source.mutableCopy() as NSMutableArray
        
        while copy.count > 0 {
            var index:Int = Int(rand()) % (copy.count)
            
            let objectToMove: AnyObject! = copy.objectAtIndex(index)
            
            shuffled.addObject(objectToMove)
            copy.removeObjectAtIndex(index)
        }
        
        return shuffled
    }
}
