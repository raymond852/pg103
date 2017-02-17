//
//  UIBarButtonItem+Closure.swift
//  XFBConsumer
//
//  Created by hy110831 on 3/30/16.
//  Copyright © 2016 hy110831. All rights reserved.
//

import Foundation
import UIKit

public typealias BarButtonHandler = (_ sender: UIBarButtonItem) -> Void
private var associatedEventHandle: UInt8 = 0

extension UIBarButtonItem {
    
    fileprivate var closuresWrapper: ClosureWrapper? {
        get {
            return objc_getAssociatedObject(self, &associatedEventHandle) as? ClosureWrapper
        }
        
        set {
            objc_setAssociatedObject(self, &associatedEventHandle, newValue,
                                     objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public convenience init(image: UIImage?, style: UIBarButtonItemStyle, handler: @escaping BarButtonHandler) {
        self.init(image: image, style: style, target: nil, action: #selector(UIBarButtonItem.handleAction))
        self.closuresWrapper = ClosureWrapper(handler: handler)
        self.target = self
    }
    
    public convenience init(title: String, style: UIBarButtonItemStyle, handler: @escaping BarButtonHandler) {
        self.init(title: title, style: style, target: nil, action: #selector(UIBarButtonItem.handleAction))
        self.closuresWrapper = ClosureWrapper(handler: handler)
        self.target = self
    }
    
    // MARK: Private methods
    @objc
    fileprivate func handleAction() {
        self.closuresWrapper?.handler(self)
    }
    
    
}

// MARK: - Private classes
private final class ClosureWrapper {
    fileprivate var handler: BarButtonHandler
    
    init(handler: @escaping BarButtonHandler) {
        self.handler = handler
    }
}
