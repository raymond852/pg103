//
//  UIButton+BackgroundColor.swift
//  gzstudy
//
//  Created by hy110831 on 10/19/16.
//  Copyright © 2016 hy110831. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
extension UIButton {
    
    @IBInspectable var corlorForBackgroundColor: UIColor! {
        set {
            let image = UIImage.fromColor(newValue, width: 1, height: 1)
            self.setBackgroundImage(image, for: .normal)
        }
        get {
            return nil
        }
    }
    
    @IBInspectable var corlorForBackgroundColorHighlighted: UIColor! {
        set {
            let image = UIImage.fromColor(newValue, width: 1, height: 1)
            self.setBackgroundImage(image, for: .highlighted)
        }
        get {
            return nil
        }
    }
    
}
