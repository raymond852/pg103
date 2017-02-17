//
//  UITextField+LeftImage.swift
//  gzstudy
//
//  Created by hy110831 on 10/19/16.
//  Copyright © 2016 hy110831. All rights reserved.
//

import Foundation
import UIKit

protocol UITextFieldLeftImage:class {
    var leftImage:UIImage? {get set}
    var leftImageOffset:CGFloat? {get set}
}

extension UITextField {
    
    @IBInspectable var leftImage: UIImage? {
        set {
            let leftImageOffset:CGFloat = 10
            if newValue != nil {
                let leftImgView = UIImageView(image: newValue)
                leftImgView.contentMode = .scaleAspectFit
                leftImgView.frame = CGRect(x: leftImageOffset,
                                           y: 0,
                                           width: leftImgView.image!.size.width,
                                           height: leftImgView.image!.size.height)
                leftImgView.tag = 110
                let containerView = UIView()
                containerView.frame = CGRect(x:0.0, y:0.0, width: leftImgView.image!.size.width
                    + leftImageOffset, height: leftImgView.image!.size.height)
                containerView.addSubview(leftImgView)
                leftView = containerView
                containerView.centerY = frame.height / 2
                leftViewMode = .always
            }
        }
        
        get {
            if let leftView = self.leftView {
                if let leftImgView = leftView.viewWithTag(110) as? UIImageView {
                    return leftImgView.image
                }
            }
            return nil
        }
    }
    
    @IBInspectable var leftImageOffset:CGFloat {
        set {
            if let leftContainer = leftView {
                if let image = leftContainer.viewWithTag(110) as? UIImageView {
                    let value = newValue
                    leftContainer.width = image.bounds.width + value
                    if let imageView = leftContainer.viewWithTag(110) {
                        imageView.x = value
                    }
                }
            }
        }
        get {
            if let leftContainer = leftView {
                if let image = leftContainer.viewWithTag(110) as? UIImageView {
                    return image.x
                }
            }
            return 0
        }
    }
    
}
