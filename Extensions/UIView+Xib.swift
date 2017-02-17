//
//  UIView+Xib.swift
//  gzstudy
//
//  Created by hy110831 on 10/20/16.
//  Copyright © 2016 hy110831. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    class func instantiateFromXib<T:UIView>(selfAsOwner:Bool = false)-> T {
        if selfAsOwner {
            let view = T()
            return Bundle.main.loadNibNamed(String(describing: T.self), owner: view, options:nil)![0] as! T
        }
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }

}
