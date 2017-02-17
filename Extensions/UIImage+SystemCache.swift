//
//  UIImage+SystemCache.swift
//  XFBConsumer
//
//  Created by hy110831 on 4/1/16.
//  Copyright © 2016 hy110831. All rights reserved.
//

import UIKit

extension UIImage {
    convenience init(named:String, cached:Bool){
        if cached == true {
            self.init(named:named)!
        } else {
            let bundlePath = Bundle.main.bundlePath
            let filePath = (bundlePath as NSString).appendingPathComponent(named)
            self.init(contentsOfFile: filePath)!
        }
    }
}
