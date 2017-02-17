//
//  H1VC.swift
//  pg102
//
//  Created by hy110831 on 1/13/17.
//  Copyright © 2017 hy110831. All rights reserved.
//

import UIKit
import pop

class H1VC: BaseViewController {

    @IBOutlet weak var imageView:UIImageView!
    @IBOutlet weak var closeBtn:UIButton!
    
    @IBOutlet weak var btn1:UIButton!
    @IBOutlet weak var btn2:UIButton!
    @IBOutlet weak var btn3:UIButton!
    @IBOutlet weak var btn4:UIButton!
    @IBOutlet weak var btn5:UIButton!
    @IBOutlet weak var btn6:UIButton!
    
    @IBOutlet weak var img1:UIImageView!
    @IBOutlet weak var img2:UIImageView!
    @IBOutlet weak var img3:UIImageView!
    @IBOutlet weak var img4:UIImageView!
    @IBOutlet weak var img5:UIImageView!
    @IBOutlet weak var img6:UIImageView!
    
    var shouldStartFaceCountdown:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        closeBtn.isExclusiveTouch = true
        closeBtn.addTarget(.touchUpInside) { 
            [unowned self] in
            Analytics.sharedInstance.appendPageCodeCount(with: "E1", isHuman: true)
            let _ = self.navigationController?.popViewController(animated: true)
        }
        
        btn1.isExclusiveTouch = true
        btn1.addTarget(.touchUpInside) { 
            [unowned self] in
            self.onHairTypeBtnClick(at: 1)
        }
        
        btn2.isExclusiveTouch = true
        btn2.addTarget(.touchUpInside) {
            [unowned self] in
            self.onHairTypeBtnClick(at: 2)
        }
        
        btn3.isExclusiveTouch = true
        btn3.addTarget(.touchUpInside) {
            [unowned self] in
            self.onHairTypeBtnClick(at: 3)
        }
        
        btn4.isExclusiveTouch = true
        btn4.addTarget(.touchUpInside) {
            [unowned self] in
            self.onHairTypeBtnClick(at: 4)
        }
        
        btn5.isExclusiveTouch = true
        btn5.addTarget(.touchUpInside) {
            [unowned self] in
            self.onHairTypeBtnClick(at: 5)
        }
        
        btn6.isExclusiveTouch = true
        btn6.addTarget(.touchUpInside) {
            [unowned self] in
            self.onHairTypeBtnClick(at: 6)
        }
        
        let images : [UIImageView] = [img1, img2, img3, img4, img5, img6]
        for img in images {
            var anim = POPBasicAnimation(propertyNamed: kPOPViewScaleXY)
            anim?.toValue = NSValue(cgSize: CGSize(width: 0.6, height: 0.6))
            anim?.autoreverses = true
            anim?.repeatForever = true
            img.pop_add(anim, forKey: "scale")
            
            anim = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
            anim?.fromValue = 0.3
            anim?.toValue = 1
            anim?.autoreverses = true
            anim?.repeatForever = true
            img.pop_add(anim, forKey: "alpha")
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func startToRootViewControllerCountDown() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 10, execute: { [weak self] in
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

extension H1VC {
    
    func onHairTypeBtnClick(at index:Int) {
        let vc = IxVC.instantiateFromStoryboard()
        switch index {
        case 1:
            vc.series = 1
        case 2:
            vc.series = 3
        case 3:
            vc.series = 4
        case 4:
            vc.series = 5
        case 5:
            vc.series = 6
        default:
            vc.series = 2
        }
        Analytics.sharedInstance.appendPageCodeCount(with: "Ix_\(vc.series!)", isHuman: true)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
