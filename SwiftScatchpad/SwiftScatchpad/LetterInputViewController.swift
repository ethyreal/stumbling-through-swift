//
//  LetterInputViewController.swift
//  SwiftScatchpad
//
//  Created by George Webster on 7/6/14.
//  Copyright (c) 2014 George Webster. All rights reserved.
//

import UIKit

class LetterInputViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var textField:UITextField
    @IBOutlet var enterButton:UIButton
    
    init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder);
    }
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Letter Tile Input"

        self.textField.becomeFirstResponder()

        self.updateTextFieldState(self.textField)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // UITextFieldDelegate methods
    
    func textFieldDidBeginEditing( textField: UITextField!) {
        self.updateTextFieldState(textField)
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        
        if ( textField.text.isEmpty) {
            return false;
        }
        self.performSegueWithIdentifier("letterTilesSegue", sender: self.enterButton)
        
        return true;
    }
    
    func textField(textField: UITextField!,
        shouldChangeCharactersInRange range: NSRange,
        replacementString string: String!) -> Bool {
            
            self.updateTextFieldState(textField)
            
            return true
    }
    
    func updateTextFieldState( textField: UITextField ) {
        if textField.text.isEmpty {
            self.enterButton.enabled = false
        } else {
            self.enterButton.enabled = true
        }
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        if segue {

            self.textField.resignFirstResponder()
            
            let vc:LetterTilesViewController = segue!.destinationViewController as LetterTilesViewController
            
            vc.characters = textField.text
        }
        
    }

}
