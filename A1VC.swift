//
//  A1VC.swift
//  pg102
//
//  Created by hy110831 on 1/15/17.
//  Copyright © 2017 hy110831. All rights reserved.
//

import UIKit
import SnapKit

class A1VC: BaseViewController {
    
    var isPlayingVideo:Bool {
        get {
            if let currentNavVC = self.presentedViewController as? InteractNavVC {
                if currentNavVC.visibleViewController is B1VC {
                    return true
                }
            }
            return false
        }
    }
    
    var interactNavVC:InteractNavVC? {
        if let currentNavVC = self.presentedViewController as? InteractNavVC {
            return currentNavVC
        }
        return nil
    }
    
    var isUserInteracting:Bool {
        get {
            if self.presentedViewController is InteractNavVC {
                return true
            }
            return false
        }
    }
    
    var bgImage:UIImageViewAligned!
    
    
    lazy var lastLevel1PickupDict:[Int:Int] = [:]
    
    lazy var brightnessControlQueue:DispatchQueue = DispatchQueue(label: "brightness")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bgImage = UIImageViewAligned()
        self.view.addSubview(bgImage)
        bgImage.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        bgImage.contentMode = .scaleAspectFill
        bgImage.alignLeft = true
        bgImage.image = UIImage(named: "A1.jpg", cached: false)
        
        NotificationCenter.default.addObserver(self, selector: #selector(A1VC.faceStateChanged(_:)), name: NSNotification.Name(rawValue: FaceDectection.NOTIF_FACE_DETECTION_STATE_CHANGED), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(A1VC.levelStateChanged(_:)), name: NSNotification.Name(rawValue: ItemPickupDectection.NOTIF_ITEM_PICKUP_DETECTION), object: nil)
        
        startBrightnessControlCountdown()
    }
    
    func startBrightnessControlCountdown() {
        brightnessControlQueue.async { [weak self] in
            self?.brightnessControlQueue.asyncAfter(deadline: .now() + 720) {
                [weak self] in
                
                if self?.interactNavVC != nil {
                    self?.startBrightnessControlCountdown()
                } else if FaceDectection.sharedInstance.detectionState != .noFace {
                    self?.startBrightnessControlCountdown()
                } else {
                    self?.dimBackground()
                }
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func faceStateChanged(_ notification:Notification) {
        switch FaceDectection.sharedInstance.detectionState {
        case .detectingGender:
            undimBackground()
            Analytics.sharedInstance.startSession()
            Analytics.sharedInstance.gender = "f"
            if !isPlayingVideo && !isUserInteracting {
                self.presentVideo()
            }
            break
        case .detectedGender:
            Analytics.sharedInstance.gender = "m"
            break
        case .noFace:
            if let navVC = interactNavVC {
                let now = Date().timeIntervalSince1970
                if navVC.fireInteractTimestamp > now {
                    DispatchQueue.main.asyncAfter(deadline: .now() + navVC.fireInteractTimestamp - now + 1, execute: {
                        [unowned self] in
                        self._faceStateChanged()
                    })
                } else {
                    if notification.object is FaceDectection {
                        let duration = Int(now) - Int(FaceDetectionConfig.FACE_DETECTION_TIMER_WAIT_TIME) - Analytics.sharedInstance.t
                        if duration > 0 {
                            Analytics.sharedInstance.duration = duration
                        } else {
                            Logger.error("calculated duration < 0")
                            Analytics.sharedInstance.gender = nil
                        }
                    }
                    shutdown()
                }
            } else {
                let now = Int(Date().timeIntervalSince1970)
                let duration = now - Int(FaceDetectionConfig.FACE_DETECTION_TIMER_WAIT_TIME) - Analytics.sharedInstance.t
                if duration > 0 {
                    Analytics.sharedInstance.duration = duration
                } else {
                    Logger.error("calculated duration < 0")
                    Analytics.sharedInstance.gender = nil
                }
                shutdown()
            }
            break
        default:
            break
        }
    }
    
    func _faceStateChanged() {
        switch FaceDectection.sharedInstance.detectionState {
        case .detectingGender:
            if !isPlayingVideo && !isUserInteracting {
                self.presentVideo()
            }
            break
        case .noFace:
            if let navVC = interactNavVC {
                let now = Date().timeIntervalSince1970
                if navVC.fireInteractTimestamp > now {
                    DispatchQueue.main.asyncAfter(deadline: .now() + navVC.fireInteractTimestamp - now + 1, execute: {
                        [unowned self] in
                        self._faceStateChanged()
                    })
                } else {
                    let duration = Int(now) - Int(navVC.MAX_IDLE_TIME) - Analytics.sharedInstance.t
                    if duration > 0 {
                        Analytics.sharedInstance.duration = duration
                    } else {
                        Logger.error("calculated duration < 0")
                        Analytics.sharedInstance.gender = nil
                    }
                    shutdown()
                }
            } else {
                Logger.error("should never be here")
                Analytics.sharedInstance.duration = nil
                Analytics.sharedInstance.gender = nil
                shutdown()
            }
            break
        default:
            break
        }
    }
    
    func levelStateChanged(_ notification:Notification) {
        if let userInfo = notification.userInfo {
            if let level = userInfo[ItemPickupDectection.KEY_LEVEL_CHANGE] as? Int, let state = userInfo[ItemPickupDectection.KEY_LEVEL_STATE] as? ItemState {
                switch level {
                case 11, 12, 13, 14, 15:
                    if state == .pickup {
                        self.undimBackground()
                        let targetVC = FxVC.instantiateFromStoryboard()
                        targetVC.index = level - 10
                        Analytics.sharedInstance.startSession()
                        let now = Int(Date().timeIntervalSince1970)
                        if let lastTime = lastLevel1PickupDict[level] {
                            if now - lastTime >= 1 {
                                Analytics.sharedInstance.appendLevel1ItemVal(id: level)
                            }
                        } else {
                            Analytics.sharedInstance.appendLevel1ItemVal(id: level)
                        }
                        Analytics.sharedInstance.appendPageCodeCount(with: "Fx_\(level)", isHuman: true)
                        if let navVC = self.interactNavVC {
                            if FaceDectection.sharedInstance.detectionState == .noFace {
                                targetVC.shouldStartFaceCountdown = true
                            }
                            navVC.setViewControllers([E1VC.instantiateFromStoryboard(), targetVC], animated: true)
                        } else {
                            let navVC = InteractNavVC()
                            if FaceDectection.sharedInstance.detectionState == .noFace {
                                targetVC.shouldStartFaceCountdown = true
                            }
                            navVC.setViewControllers([E1VC.instantiateFromStoryboard(), targetVC], animated: false)
                            self.present(navVC, animated:true, completion:nil)
                        }
                    }
                    break
                case 2, 3, 4:
                    if state == .pickup {
                        undimBackground()
                        Analytics.sharedInstance.startSession()
                        Analytics.sharedInstance.updateWeightByLevelWithDebounce(timeInterval: 2, level: level)
                        
                        if let navVC = self.interactNavVC {
                            if navVC.visibleViewController is H1VC {
                                return
                            }
                            Analytics.sharedInstance.appendPageCodeCount(with: "H1", isHuman: true)
                            let targetVC = H1VC.instantiateFromStoryboard()
                            if FaceDectection.sharedInstance.detectionState == .noFace {
                                targetVC.shouldStartFaceCountdown = true
                            }
                            navVC.setViewControllers([E1VC.instantiateFromStoryboard(), targetVC], animated: true)
                        } else {
                            let navVC = InteractNavVC()
                            let targetVC = H1VC.instantiateFromStoryboard()
                            Analytics.sharedInstance.appendPageCodeCount(with: "H1", isHuman: true)
                            if FaceDectection.sharedInstance.detectionState == .noFace {
                                targetVC.shouldStartFaceCountdown = true
                            }
                            navVC.setViewControllers([E1VC.instantiateFromStoryboard(), targetVC], animated: false)
                            self.present(navVC, animated:true, completion:nil)
                        }
                    }
                    break
                default:
                    break
                }
            }
        }
    }
    
    func shutdown() {
        Logger.info("shutdown")
        Analytics.sharedInstance.endSession()
        self.dismiss(animated: true, completion: nil)
        CC2541.shared.lightOffLed()
    }
    
    func dimBackground() {
        UIScreen.main.brightness = 0
    }
    
    func undimBackground() {
        UIScreen.main.brightness = 1
        startBrightnessControlCountdown()
    }

}

extension A1VC {
    
    func presentVideo() {
        let b1VC = B1VC()
        let vc = InteractNavVC(rootViewController: b1VC)
        self.present(vc, animated: true, completion: nil)
    }
    
    
}
