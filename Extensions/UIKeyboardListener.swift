//
//  UIKeyboardListener.swift
//  gzstudy
//
//  Created by hy110831 on 10/24/16.
//  Copyright © 2016 hy110831. All rights reserved.
//

import Foundation

class UIKeyboardListener:NSObject {
    
    static var shared = UIKeyboardListener()
    
    open private(set) var visible:Bool = false
    open private(set) var keyboardHeight:CGFloat = 0
    
    override init() {
        super.init()
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(self.noticeShowKeyboard), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        center.addObserver(self, selector: #selector(self.noticeHideKeyboard), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func noticeShowKeyboard(_ inNotification: Notification) {
        if let userInfo = inNotification.userInfo {
            if let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                self.keyboardHeight = keyboardSize.size.height
                self.visible = true
            }
        }
    }
    
    func noticeHideKeyboard(_ inNotification: Notification) {
        self.keyboardHeight = 0
        self.visible = false
    }
    
}
