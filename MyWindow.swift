//
//  MyWindow.swift
//  pg102
//
//  Created by hy110831 on 1/19/17.
//  Copyright © 2017 hy110831. All rights reserved.
//

import UIKit

class MyWindow: UIWindow {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    weak var delegate:MyWindowDelegate?
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        self.delegate?.windowDidClick()
        return super.hitTest(point, with: event)
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesBegan(touches, with: event)
//        self.delegate?.windowDidClick()
//    }
//    
//    @available(iOS 9.0, *)
//    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
//        super.pressesBegan(presses, with: event)
//        self.delegate?.windowDidClick()
//    }

}


protocol MyWindowDelegate:class {
    
    func windowDidClick()
    
}
