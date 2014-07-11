//
//  LetterTilesViewController.swift
//  SwiftScatchpad
//
//  Created by George Webster on 7/6/14.
//  Copyright (c) 2014 George Webster. All rights reserved.
//

import UIKit

class LetterTilesViewController: UIViewController, TileViewDelegate, UIAlertViewDelegate {

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
    
    init(coder aDecoder: NSCoder!) {
        
        
        super.init(coder: aDecoder)
    }
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewWillAppear(animated: Bool) {
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

            let charCount:NSNumber = self.charactersNoWhiteSpace!.length
            
            let tv = self.tileViews!.lastObject as TileView
            
            let tileTotalWidth = (charCount.floatValue * CGRectGetWidth(tv.frame)) + (charCount.floatValue * bufferX ) - bufferX // doesn't count foriegn charactes!
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
            
            let charCount:NSNumber = self.charactersNoWhiteSpace!.length
            
            let tv = self.tileViews!.lastObject as TileView
            
            var outlineFrame = CGRectInset( tv.frame, -6, -6)
            
            let tileTotalWidth = (charCount.floatValue * CGRectGetWidth(outlineFrame)) + (charCount.floatValue * bufferX ) - bufferX // doesn't count foriegn charactes!
            let startX:CGFloat = CGRectGetMidX(self.view.bounds) - ( tileTotalWidth / 2 )
            
            let startY:CGFloat = self.topLayoutGuide.length + ( CGRectGetHeight(self.view.bounds) / 4 )
            
            var currentX = startX
            var currentY = startY
            
            for obj:AnyObject in self.tileViews! {
                
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
        }
    }
    
    // TileViewDelegate
    
    func tileViewWillBeginPanning( tileView:TileView ) {
        self.currentTile = tileView
        
        if tileView.outlineView {
            if tileView.outlineView!.tileView {
                tileView.outlineView!.tileView = nil
            }
            tileView.outlineView = nil
        }
    }
    
    func tileViewWillSnapToOutlineView( tileView:TileView, outlineView:OutlineView ) {
        tileView.outlineView = outlineView
        outlineView.tileView = tileView
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
