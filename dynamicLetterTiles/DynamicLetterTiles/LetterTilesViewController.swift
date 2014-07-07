//
//  LetterTilesViewController.swift
//  SwiftScatchpad
//
//  Created by George Webster on 7/6/14.
//  Copyright (c) 2014 George Webster. All rights reserved.
//

import UIKit

class LetterTilesViewController: UIViewController {

    var characters:NSString? = nil {
        didSet {
            if self.characters {
                self.tiles = NSMutableArray(capacity: self.characters!.length)
            }
        }
    }
    var tiles:NSMutableArray? = nil
    
    init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTiles()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func setupTiles() {
        
        if self.characters {
            
            let upperCaseCharacters:NSString = self.characters!.uppercaseString
            let charactersNoWhiteSpace:NSString = upperCaseCharacters.stringByTrimmingCharactersInSet( NSCharacterSet.whitespaceAndNewlineCharacterSet() )
            
            let startX:CGFloat = 10.0
            let startY:CGFloat = CGRectGetMidY(self.view.bounds)

            let bufferX:CGFloat = 5.0
            let bufferY:CGFloat = 5.0
            
            var currentX = startX
            var currentY = startY

            let enumerationOptions: NSStringEnumerationOptions = .ByComposedCharacterSequences
            
            let range: NSRange = NSMakeRange(0, charactersNoWhiteSpace.length)
            
            charactersNoWhiteSpace.enumerateSubstringsInRange( range, options: enumerationOptions ) { character, _, _, stop in
                
                let tileImage   = UIImage(named: character)
                let tileView    = UIImageView(image: tileImage)
                
                var tileFrame = tileView.frame
                
                tileFrame.origin.x = currentX
                tileFrame.origin.y = currentY
                
                tileView.frame = tileFrame
                
                self.view.addSubview(tileView)
                
                if self.tiles {
                    self.tiles!.addObject(tileView)
                }
                
                currentX += CGRectGetWidth(tileFrame) + bufferX
                
                if currentX + CGRectGetWidth(tileFrame) > CGRectGetWidth(self.view.bounds) {
                    currentX = startX
                    currentY = CGRectGetMaxY(tileFrame) + bufferY
                }
                
            }
            
            
        }
            
        
    }

}
