//
//  EntryVC.swift
//  pg
//
//  Created by hy110831 on 8/19/16.
//  Copyright © 2016 hy110831. All rights reserved.
//

import UIKit
import SwiftyButton
import pop
import SnapKit

class E1VC: BaseViewController {
    
    @IBOutlet weak var couponBtn:UIButton!
    @IBOutlet weak var guideBtn:UIButton!
    @IBOutlet weak var couponHandBtn:UIButton!
    @IBOutlet weak var guideHandBtn:UIButton!
    
    @IBOutlet weak var step1Btn:UIButton!
    @IBOutlet weak var step2Btn:UIButton!
    @IBOutlet weak var step3Btn:UIButton!
    @IBOutlet weak var step4Btn:UIButton!
    @IBOutlet weak var step5Btn:UIButton!
    
    @IBOutlet weak var step1Img:UIImageView!
    @IBOutlet weak var step2Img:UIImageView!
    @IBOutlet weak var step3Img:UIImageView!
    @IBOutlet weak var step4Img:UIImageView!
    @IBOutlet weak var step5Img:UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func setupView() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.edgesForExtendedLayout = UIRectEdge.all
        self.view.backgroundColor = UIColor.white
        
        step1Btn.isExclusiveTouch = true
        step1Btn.addTarget(.touchUpInside) { 
            [unowned self] in
            self.onStep1Click()
        }
        
        step1Img.isUserInteractionEnabled = true
        step1Img.isExclusiveTouch = true
        step1Img.addSingleTapGestureRecognizerWithResponder {  [unowned self]  (tap) in
            self.onStep1Click()
        }
        var anim = POPBasicAnimation(propertyNamed: kPOPViewScaleXY)
        anim?.toValue = NSValue(cgSize: CGSize(width: 1.5, height: 1.5))
        anim?.autoreverses = true
        anim?.repeatForever = true
        step1Img.pop_add(anim, forKey: "scale")
        
        anim = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        anim?.fromValue = 0.3
        anim?.toValue = 1
        anim?.autoreverses = true
        anim?.repeatForever = true
        step1Img.pop_add(anim, forKey: "alpha")
        
        
        step2Btn.isExclusiveTouch = true
        step2Btn.addTarget(.touchUpInside) {
            [unowned self] in
            self.onStep2Click()
        }
        
        step2Img.isUserInteractionEnabled = true
        step2Img.isExclusiveTouch = true
        step2Img.addSingleTapGestureRecognizerWithResponder {  [unowned self]  (tap) in
            self.onStep2Click()
        }
        
        anim = POPBasicAnimation(propertyNamed: kPOPViewScaleXY)
        anim?.toValue = NSValue(cgSize: CGSize(width: 1.5, height: 1.5))
        anim?.autoreverses = true
        anim?.repeatForever = true
        step2Img.pop_add(anim, forKey: "scale")
        
        anim = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        anim?.fromValue = 0.3
        anim?.toValue = 1
        anim?.autoreverses = true
        anim?.repeatForever = true
        step2Img.pop_add(anim, forKey: "alpha")
        
        step3Btn.isExclusiveTouch = true
        step3Btn.addTarget(.touchUpInside) {
            [unowned self] in
            self.onStep3Click()
        }
        
        step3Img.isUserInteractionEnabled = true
        step3Img.isExclusiveTouch = true
        step3Img.addSingleTapGestureRecognizerWithResponder {  [unowned self]  (tap) in
            self.onStep3Click()
        }
        
        anim = POPBasicAnimation(propertyNamed: kPOPViewScaleXY)
        anim?.toValue = NSValue(cgSize: CGSize(width: 1.5, height: 1.5))
        anim?.autoreverses = true
        anim?.repeatForever = true
        step3Img.pop_add(anim, forKey: "scale")
        
        anim = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        anim?.fromValue = 0.3
        anim?.toValue = 1
        anim?.autoreverses = true
        anim?.repeatForever = true
        step3Img.pop_add(anim, forKey: "alpha")
        
        step4Btn.isExclusiveTouch = true
        step4Btn.addTarget(.touchUpInside) {
            [unowned self] in
            self.onStep4Click()
        }
        
        step4Img.isUserInteractionEnabled = true
        step4Img.isExclusiveTouch = true
        step4Img.addSingleTapGestureRecognizerWithResponder {  [unowned self]  (tap) in
            self.onStep4Click()
        }
        
        anim = POPBasicAnimation(propertyNamed: kPOPViewScaleXY)
        anim?.toValue = NSValue(cgSize: CGSize(width: 1.5, height: 1.5))
        anim?.autoreverses = true
        anim?.repeatForever = true
        step4Img.pop_add(anim, forKey: "scale")
        
        anim = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        anim?.fromValue = 0.3
        anim?.toValue = 1
        anim?.autoreverses = true
        anim?.repeatForever = true
        step4Img.pop_add(anim, forKey: "alpha")
        
        step5Btn.isExclusiveTouch = true
        step5Btn.addTarget(.touchUpInside) {
            [unowned self] in
            self.onStep5Click()
        }
        
        step5Img.isUserInteractionEnabled = true
        step5Img.isExclusiveTouch = true
        step5Img.addSingleTapGestureRecognizerWithResponder {  [unowned self]  (tap) in
            self.onStep5Click()
        }
        
        anim = POPBasicAnimation(propertyNamed: kPOPViewScaleXY)
        anim?.toValue = NSValue(cgSize: CGSize(width: 1.5, height: 1.5))
        anim?.autoreverses = true
        anim?.repeatForever = true
        step5Img.pop_add(anim, forKey: "scale")
        
        anim = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        anim?.fromValue = 0.3
        anim?.toValue = 1
        anim?.autoreverses = true
        anim?.repeatForever = true
        step5Img.pop_add(anim, forKey: "alpha")
        
        guideBtn.isExclusiveTouch = true
        guideBtn.addTarget(.touchUpInside) { 
            [unowned self] in
            self.onGuideClick()
        }
        
        couponBtn.isExclusiveTouch = true
        couponBtn.addTarget(.touchUpInside) {
            [unowned self] in
            self.onCouponClick()
        }
        
        guideHandBtn.isExclusiveTouch = true
        guideHandBtn.addTarget(.touchUpInside) { 
            [unowned self] in
            self.onGuideClick()
        }
        
        anim = POPBasicAnimation(propertyNamed: kPOPViewScaleXY)
        anim?.toValue = NSValue(cgSize: CGSize(width: 0.8, height: 0.8))
        anim?.autoreverses = true
        anim?.repeatForever = true
        
        guideHandBtn.pop_add(anim, forKey: "scale")
        
        anim = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        anim?.fromValue = 0.3
        anim?.toValue = 1
        anim?.autoreverses = true
        anim?.repeatForever = true
        step5Img.pop_add(anim, forKey: "alpha")
        
        guideHandBtn.pop_add(anim, forKey: "alpha")
        
        couponHandBtn.isExclusiveTouch = true
        couponHandBtn.addTarget(.touchUpInside) {
            [unowned self] in
            self.onCouponClick()
        }
        
        anim = POPBasicAnimation(propertyNamed: kPOPViewScaleXY)
        anim?.toValue = NSValue(cgSize: CGSize(width: 0.8, height: 0.8))
        anim?.autoreverses = true
        anim?.repeatForever = true
        
        couponHandBtn.pop_add(anim, forKey: "scale")
        
        anim = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        anim?.fromValue = 0.3
        anim?.toValue = 1
        anim?.autoreverses = true
        anim?.repeatForever = true
        step5Img.pop_add(anim, forKey: "alpha")
        
        couponHandBtn.pop_add(anim, forKey: "alpha")
        
        
    }
    
    
   

}


extension E1VC {
    
    func onStep1Click() {
        let vc = FxVC.instantiateFromStoryboard()
        vc.index = 1
        Analytics.sharedInstance.appendPageCodeCount(with: "Fx_11", isHuman: true)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func onStep2Click() {
        let vc = FxVC.instantiateFromStoryboard()
        vc.index = 2
        Analytics.sharedInstance.appendPageCodeCount(with: "Fx_12", isHuman: true)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func onStep3Click() {
        let vc = FxVC.instantiateFromStoryboard()
        vc.index = 3
        Analytics.sharedInstance.appendPageCodeCount(with: "Fx_13", isHuman: true)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func onStep4Click() {
        let vc = FxVC.instantiateFromStoryboard()
        vc.index = 4
        Analytics.sharedInstance.appendPageCodeCount(with: "Fx_14", isHuman: true)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func onStep5Click() {
        let vc = FxVC.instantiateFromStoryboard()
        vc.index = 5
        Analytics.sharedInstance.appendPageCodeCount(with: "Fx_15", isHuman: true)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func onGuideClick() {
//        let vc = K1VC()
        Analytics.sharedInstance.appendPageCodeCount(with: "H1", isHuman: true)
        let vc = H1VC.instantiateFromStoryboard()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func onCouponClick() {
        Analytics.sharedInstance.appendPageCodeCount(with: "G1", isHuman: true)
        let vc = G1VC.instantiateFromStoryboard()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
