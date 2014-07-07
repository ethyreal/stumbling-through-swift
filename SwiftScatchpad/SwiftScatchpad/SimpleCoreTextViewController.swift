//
//  SimpleCoreTextViewController.swift
//  SwiftScatchpad
//
//  Created by George Webster on 7/2/14.
//  Copyright (c) 2014 George Webster. All rights reserved.
//

import UIKit

class SimpleCoreTextViewController: UIViewController {
                            
    var textView: SimpleCoreTextView? = nil
    
    @IBOutlet var textViewContainer: UIScrollView
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Simple CoreText Example"

        setupTextView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // setup text
    
    func setupTextView() {

        var str:NSString = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ipsum dolor sit amet, consectetur adipiscing elit."

        self.textView = SimpleCoreTextView(frame: self.textViewContainer.bounds, text: str)
        
        self.textViewContainer.addSubview(self.textView)
        
        //self.textViewContainer.contentSize = self.textView.frame.size
        
        
        let color = UIColor.redColor()

        let enumerationOptions: NSStringEnumerationOptions = .ByWords
        
        let range: NSRange = NSMakeRange(0, str.length)
        
        if let attrString = self.textView?.attrString {
            
            str.enumerateSubstringsInRange( range, options: enumerationOptions ) { substring, substringRange, enclosingRange, stop in
                if ( substring == "ipsum" ) {
                    attrString.setAttributes( [NSForegroundColorAttributeName : color], range: substringRange )
                }
            }
            self.textView?.setNeedsDisplay()
        }
        
        
    }


}

