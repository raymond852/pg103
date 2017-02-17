//
//  IxyVC.swift
//  pg102
//
//  Created by hy110831 on 1/16/17.
//  Copyright © 2017 hy110831. All rights reserved.
//

import UIKit

class IxyVC: BaseViewController {
    
    @IBOutlet weak var imgView:UIImageView!
    @IBOutlet weak var closeBtn:UIButton!
    
    var series:Int!
    var index:Int!
    
    let seriesIndex2Intro: [Int:String] = [
        10: "I-1_06.jpg",
        11: "I-1_12.jpg",
        12: "I-x_2.jpg",
        13: "I-x_3.jpg",
        
        20: "I-2_47.jpg",
        21: "I-2_47.jpg",
        22: "I-x_3.jpg",
        23: "I-x_2.jpg",
        
        30: "I-1_06.jpg",
        31: "I-1_12.jpg",
        32: "I-x_2.jpg",
        33: "I-x_3.jpg",
        
        40: "I-4_44.jpg",
        41: "I-x_3.jpg",
        
        50: "I-5_20.jpg",
        51: "I-5_21.jpg",
        52: "I-x_3.jpg",
        
        
        60: "I-6_33.jpg",
        61: "I-6_37.jpg",
        62: "I-x_1.jpg",
        63: "I-x_3.jpg",
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        imgView.image = UIImage(named:seriesIndex2Intro[series * 10 + index]!, cached: false)
        closeBtn.addTarget(.touchUpInside) { 
            [unowned self] in
            Analytics.sharedInstance.appendPageCodeCount(with: "Ixx_\(self.series!)_\(self.index!)", isHuman: true)
            let _ = self.navigationController?.popViewController(animated: true)
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
    


}
