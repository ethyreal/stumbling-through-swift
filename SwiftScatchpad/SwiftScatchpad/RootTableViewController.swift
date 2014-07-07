//
//  RootTableViewController.swift
//  SwiftScatchpad
//
//  Created by George Webster on 7/2/14.
//  Copyright (c) 2014 George Webster. All rights reserved.
//

import UIKit

class RootTableViewController: UITableViewController {

    init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
    init(style: UITableViewStyle) {
        super.init(style: style)
        // Custom initialization
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Samples"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
