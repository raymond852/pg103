//
//  BaseViewController.swift
//  pg
//
//  Created by hy110831 on 8/22/16.
//  Copyright © 2016 hy110831. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    deinit {
        Logger.verbose("\(self) deinit")
    }

}
