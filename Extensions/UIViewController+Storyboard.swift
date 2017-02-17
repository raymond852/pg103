//
//  BaseViewController+Storyboard.swift
//  pg
//
//  Created by hy110831 on 9/11/16.
//  Copyright © 2016 hy110831. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController
{
    
    class func instantiateFromStoryboard() -> Self
    {
        return instantiateFromStoryboardHelper(type: self, storyboardName: "Main")
    }
    
    class func instantiateFromStoryboard(storyboardName: String) -> Self
    {
        return instantiateFromStoryboardHelper(type: self, storyboardName: storyboardName)
    }
    
    private class func instantiateFromStoryboardHelper<T:UIViewController>(type: T.Type, storyboardName: String) -> T
    {
        var storyboardId = ""

        storyboardId = NSStringFromClass(T.self).characters.split(separator: ".").map(String.init).last!
        
        let storyboad = UIStoryboard(name: storyboardName, bundle: nil)
        let controller = storyboad.instantiateViewController(withIdentifier: storyboardId) as! T
        
        return controller
    }
}
