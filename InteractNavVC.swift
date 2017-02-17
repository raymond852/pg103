//
//  InteractNavVC.swift
//  pg
//
//  Created by hy110831 on 8/24/16.
//  Copyright © 2016 hy110831. All rights reserved.
//

import UIKit


protocol InteractNavVCDelegate:class {
    func didBecomeIdle(_ vc:InteractNavVC)
}

class InteractNavVC: UINavigationController {

    var fireInteractTimestamp:TimeInterval!
    
    var MAX_IDLE_TIME:TimeInterval = 15
    
    weak var interactDelegate:InteractNavVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let window = UIApplication.shared.delegate?.window as? MyWindow {
            window.delegate = self
        }
        fireInteractTimestamp = Date().timeIntervalSince1970 + MAX_IDLE_TIME
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    func idleTimerExceeded() {
        Logger.verbose("InteractNavVC: didBecomeIdle")
        interactDelegate?.didBecomeIdle(self)
    }
    
    
    deinit {
        Logger.verbose("\(self) deinit")
    }
    
    func dimBackground() {
        UIScreen.main.brightness = 0
    }
    
    func undimBackground() {
        UIScreen.main.brightness = 10
    }

}

extension InteractNavVC: MyWindowDelegate {
    
    func windowDidClick() {
        self.fireInteractTimestamp = Date().timeIntervalSince1970 + MAX_IDLE_TIME
        Logger.verbose("InteractNavVC: Interative timer update fire date \(fireInteractTimestamp)")
    }
    
}
