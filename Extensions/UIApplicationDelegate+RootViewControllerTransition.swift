//
//  UIViewController+RootViewControllerTransition.swift
//  gzstudy
//
//  Created by hy110831 on 10/19/16.
//  Copyright © 2016 hy110831. All rights reserved.
//

import Foundation
import UIKit

extension UIApplicationDelegate {
    
    
    func changeRootViewController(desiredViewController:UIViewController) {
        
        let snapshot:UIView = (self.window?!.snapshotView(afterScreenUpdates: false))!
        desiredViewController.view.addSubview(snapshot)
        
        self.window??.rootViewController = desiredViewController
        
        UIView.animate(withDuration: 0.5, animations: {() in
            snapshot.layer.opacity = 0
            snapshot.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5)
            }, completion: {
                (value: Bool) in
                snapshot.removeFromSuperview()
        })
    }
    
}
