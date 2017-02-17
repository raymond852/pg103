//
//  IxVC.swift
//  pg102
//
//  Created by hy110831 on 1/15/17.
//  Copyright © 2017 hy110831. All rights reserved.
//

import UIKit
import pop
import SnapKit
import CoreGraphics

class IxVC: BaseViewController {

    @IBOutlet weak var imgView:UIImageView!
    @IBOutlet weak var otherProductBtn:UIButton!
    
    let BTN_SIZE:CGFloat = 100
    let DOT_SIZE:CGFloat = 20
    
    var series:Int!
    
    let indexSeriesMap:[Int:String] = [
        1 : "I-1_04.jpg",
        2 : "I-2_41.jpg",
        3 : "I-3_16.jpg",
        4 : "I-4_40.jpg",
        5 : "I-5_15.jpg",
        6 : "I-6_31.jpg"
    ]
    
    
    let indexProductBtnCenterPoint:[Int:[CGPoint]] = {
        var map:[Int:[CGPoint]] = [:]
        let arr1 = [CGPoint(x: 375, y: 613), CGPoint(x: 519, y:502), CGPoint(x: 625, y: 347), CGPoint(x: 763, y:187)]
        let arr2 = [CGPoint(x: 390, y: 526), CGPoint(x: 511, y:470), CGPoint(x: 650, y: 360), CGPoint(x: 775, y:204)]
        let arr3 = [CGPoint(x: 385, y: 538), CGPoint(x: 530, y:541), CGPoint(x: 613, y: 331), CGPoint(x: 775, y:203)]
        let arr4 = [CGPoint(x: 491, y: 445), CGPoint(x: 669, y:243)]
        let arr5 = [CGPoint(x: 389, y: 504), CGPoint(x: 541, y:510), CGPoint(x: 698, y: 200)]
        let arr6 = [CGPoint(x: 388, y: 578), CGPoint(x: 521, y:535), CGPoint(x: 631, y: 622), CGPoint(x: 763, y:185)]
        
        map = [
            1 : arr1,
            2 : arr2,
            3 : arr3,
            4 : arr4,
            5 : arr5,
            6 : arr6,
        ]
        return map
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        otherProductBtn.addTarget(.touchUpInside) { [unowned self] in
            Analytics.sharedInstance.appendPageCodeCount(with: "H1", isHuman: true)
            let _ = self.navigationController?.popViewController(animated: true)
        }
        
        imgView.image = UIImage(named: indexSeriesMap[self.series]!, cached: false)
        for (offset, centerPoint) in indexProductBtnCenterPoint[series]!.enumerated() {
            let imageView = UIImageView()
            imageView.frame = CGRect(x: 0, y: 0 , width:DOT_SIZE, height:DOT_SIZE)
            let image = UIImage(named: "ic_add.jpg", cached: true)
            imageView.image = image
            self.view.addSubview(imageView)
            imageView.center = centerPoint
            
            var anim = POPBasicAnimation(propertyNamed: kPOPViewScaleXY)
            anim?.toValue = NSValue(cgSize: CGSize(width: 1.5, height: 1.5))
            anim?.autoreverses = true
            anim?.repeatForever = true
            imageView.pop_add(anim, forKey: "scale")
            
            anim = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
            anim?.fromValue = 0.3
            anim?.toValue = 1
            anim?.autoreverses = true
            anim?.repeatForever = true
            imageView.pop_add(anim, forKey: "alpha")

            
            let btn = UIButton()
            btn.frame = CGRect(x: 0, y: 0 , width:BTN_SIZE, height:BTN_SIZE)
            self.view.addSubview(btn)
            btn.isExclusiveTouch = true
            btn.center = centerPoint
            btn.addTarget(.touchUpInside, action: {
                [unowned self] in
                self.productClickAtIndex(offset)
            })
            
        }
        
        startToRootViewControllerCountDown()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func startToRootViewControllerCountDown() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 15, execute: { [weak self] in
            if let navigationController = self?.navigationController as? InteractNavVC {
                if navigationController.fireInteractTimestamp > Date().timeIntervalSince1970 {
                    self?.startToRootViewControllerCountDown()
                } else {
                    Analytics.sharedInstance.appendPageCodeCount(with: "E1", isHuman: false)
                    let _ = self?.navigationController?.popToRootViewController(animated: true)
                    CC2541.shared.lightOffLed()
                }
            }
        })
    }
    
    func productClickAtIndex(_ index:Int) {
        let vc = IxxVC.instantiateFromStoryboard()
        vc.series = self.series
        vc.index = index
        Analytics.sharedInstance.appendPageCodeCount(with: "Ixx_\(vc.series!)_\(vc.index!)", isHuman: true)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    


}
