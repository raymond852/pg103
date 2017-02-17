 //
//  AppDelegate.swift
//  pg102
//
//  Created by hy110831 on 1/1/17.
//  Copyright © 2017 hy110831. All rights reserved.
//

import UIKit
import SnapKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.window = MyWindow(frame: UIScreen.main.bounds)
        
        
        BLEHelper.shared.addPeripheral(CC2541.shared)
        BLEHelper.shared.scan()
        
        FaceDectection.sharedInstance.startRunning()
        
        let btn = UIButton(frame: CGRect(x: 50, y:50, width:50, height:50))
        btn.setTitle("Graph", for: UIControlState.normal)
        btn.setImage(UIImage.fromColor(UIColor.green, width: 1, height: 1), for: .normal)
        self.window?.addSubview(btn)
        
        self.window?.rootViewController = A1VC()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {

    }

    func applicationWillTerminate(_ application: UIApplication) {

    }


}

