//
//  UITextField+Password.swift
//  XFBConsumer
//
//  Created by hy110831 on 4/21/16.
//  Copyright © 2016 hy110831. All rights reserved.
//

import Foundation
import UIKit


class NotificationProxy: UIView {
    
    weak var objectProtocol: NSObjectProtocol!
    
    func addObserverForName(_ name: String?, object: AnyObject?, queue: OperationQueue?, usingBlock: @escaping (Notification!) -> ()) {
        
        // Register the specified object and notification with NSNotificationCenter
        self.objectProtocol = NotificationCenter.default.addObserver(forName: name.map { NSNotification.Name(rawValue: $0) }, object: object, queue: queue, using: usingBlock)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        
        // Unregister the object from NSNotificationCenter
        NotificationCenter.default.removeObserver(self.objectProtocol)
    }
}

let NOTIFS_TAG0 = 857
let NOTIFS_TAG1 = 986

extension UITextField {
    
    func setKeyboardPasswdHidden(_ hidden:Bool) {
        if hidden == false && self.viewWithTag(NOTIFS_TAG0) == nil {
            let notifisProxy = NotificationProxy()
            self.addSubview(notifisProxy)
            notifisProxy.tag = NOTIFS_TAG0
            notifisProxy.addObserverForName(
                
            NSNotification.Name.UITextFieldTextDidChange.rawValue, object: self, queue: nil) { [unowned self] (_) in
                self.isSecureTextEntry = false
            }
            
            let notifisProxy1 = NotificationProxy()
            self.addSubview(notifisProxy1)
            notifisProxy1.addObserverForName(NSNotification.Name.UITextFieldTextDidBeginEditing.rawValue, object: self, queue: nil) { [unowned self] (_) in
                self.isSecureTextEntry = true
            }
        } else {
            if let view = self.viewWithTag(NOTIFS_TAG0) {
                view.removeFromSuperview()
            }
            if let view1 = self.viewWithTag(NOTIFS_TAG1) {
                view1.removeFromSuperview()
            }
            self.isSecureTextEntry = true
        }
    }
}
