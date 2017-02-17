//
//  UIButton+Position.swift
//  XFBConsumer
//
//  Created by hy110831 on 5/27/16.
//  Copyright © 2016 hy110831. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    func centerTextAndImage(_ spacing: CGFloat) {
        let insetAmount = spacing / 2
        imageEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: insetAmount)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: -insetAmount)
        contentEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: insetAmount)
    }
}
