//
//  UIImage+Color.swift
//  XFBConsumer
//
//  Created by hy110831 on 3/28/16.
//  Copyright © 2016 hy110831. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics

extension UIImage {
    
    static func fromColor(_ color: UIColor, width: CGFloat, height: CGFloat) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
    
}
