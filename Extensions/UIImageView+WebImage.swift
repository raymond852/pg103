//
//  UIImageView+WebImage.swift
//  XFBConsumer
//
//  Created by hy110831 on 5/20/16.
//  Copyright © 2016 hy110831. All rights reserved.
//
import UIKit
import SDWebImage

extension UIImageView {
    
    func sdcustom_setImageWithURL(_ url:URL?) {
        guard url != nil else {
            return
        }
        setIndicatorStyle(.gray)
        setShowActivityIndicator(true)
        sd_setImage(with: url)
    }
    
    func sdcustom_setImageWithURL(_ url:URL?, placeHolder:UIImage, complectionHandler: ((UIImage?, Error?, SDImageCacheType?, URL?)->())? = nil) {
        guard url != nil else {
            return
        }
        setIndicatorStyle(.gray)
        setShowActivityIndicator(true)
        sd_setImage(with: url, placeholderImage: placeHolder, options: SDWebImageOptions(), completed: { (image, error, cacheType, imageUrl) in
            complectionHandler?(image, error, cacheType, imageUrl)
            return
        })
    }
}
