//
//  UILabel+Truncated.swift
//  XFBConsumer
//
//  Created by hy110831 on 6/3/16.
//  Copyright © 2016 hy110831. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    
    func isTextTruncated() -> Bool {
        var testBounds: CGRect = self.bounds
        testBounds.size.height = CGFloat(NSIntegerMax)
        let limitActual: CGRect = self.textRect(forBounds: self.bounds, limitedToNumberOfLines: self.numberOfLines)
        let limitTest: CGRect = self.textRect(forBounds: testBounds, limitedToNumberOfLines: self.numberOfLines + 1)
        return limitTest.size.height > limitActual.size.height
    }
    
}
