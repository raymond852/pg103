//
//  FxVC.swift
//  pg102
//
//  Created by hy110831 on 1/13/17.
//  Copyright © 2017 hy110831. All rights reserved.
//

import UIKit

class FxVC: BaseViewController {
    
    @IBOutlet weak var imageView:UIImageView!
    @IBOutlet weak var closeBtn:UIButton!
    
    var index:Int!
    
    var shouldStartFaceCountdown:Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        switch (index) {
        case 1:
            self.imageView.image = UIImage(named: "F1.jpg", cached: false)
            break
        case 2:
            self.imageView.image = UIImage(named: "F2.jpg", cached: false)
            break
        case 3:
            self.imageView.image = UIImage(named: "F3.jpg", cached: false)
            break
        case 4:
            self.imageView.image = UIImage(named: "F4.jpg", cached: false)
            break
        default:
            self.imageView.image = UIImage(named: "F5.jpg", cached: false)
        }
        
        closeBtn.isExclusiveTouch = true
        closeBtn.addTarget(.touchUpInside) {
            [unowned self] in
            Analytics.sharedInstance.appendPageCodeCount(with: "E1", isHuman: true)
            let _ = self.navigationController?.popViewController(animated: true)
        }
        
        startToRootViewControllerCountDown()
        
        if shouldStartFaceCountdown {
            DispatchQueue.main.asyncAfter(deadline: .now() + FaceDetectionConfig.FACE_DETECTION_TIMER_WAIT_TIME , execute: {
                if FaceDectection.sharedInstance.detectionState == .noFace {
                    let notifs = Notification(name: Notification.Name(rawValue: FaceDectection.NOTIF_FACE_DETECTION_STATE_CHANGED), object: self)
                    NotificationCenter.default.post(notifs)
                    Logger.debug("FaceDetection: \(FaceDectection.sharedInstance.detectionState)")
                }
            })
        }
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
