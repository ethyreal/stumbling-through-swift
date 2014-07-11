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
                
                let tileView    = TileView(imageName: character, delegate: self, parentView: self.view)
                
                tileView.userInteractionEnabled = true
                tileView.layer.zPosition = 20
                
                var tileFrame = tileView.frame
                
                tileFrame.origin.x = currentX
                tileFrame.origin.y = currentY
                
                tileView.frame = tileFrame
                
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
                
                if CGRectIntersectsRect(tileView.frame, ov.frame) {
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
}
