//
//  IxxVC.swift
//  pg102
//
//  Created by hy110831 on 1/16/17.
//  Copyright © 2017 hy110831. All rights reserved.
//

import UIKit

class IxxVC: BaseViewController {
    
    @IBOutlet weak var imgView:UIImageView!
    @IBOutlet weak var closeBtn:UIButton!
    @IBOutlet weak var otherBtn:UIButton!
    
    @IBOutlet weak var tipsImg:UIImageView!
    @IBOutlet weak var tipsLine:UIImageView!
    @IBOutlet weak var tipsBtn:UIButton!
    @IBOutlet weak var commentsImg:UIImageView!
    @IBOutlet weak var commentsLine:UIImageView!
    @IBOutlet weak var commentsBtn:UIButton!
    
    
    var series:Int!
    var index:Int!
    
    var seriesIndex2Img:[Int:String] = [
        10: "I-1_05.jpg",
        11: "I-1_09.jpg",
        12: "I-1_11.jpg",
        13: "I-1_10.jpg",
        
        20: "I-2_46.jpg",
        21: "I-2_48.jpg",
        22: "I-2_50.jpg",
        23: "I-2_49.jpg",
        
        30: "I-3_23.jpg",
        31: "I-3_24.jpg",
        32: "I-3_26.jpg",
        33: "I-3_25.jpg",
        
        40: "I-4_42.jpg",
        41: "I-4_43.jpg",
        
        50: "I-5_17.jpg",
        51: "I-5_18.jpg",
        52: "I-5_19.jpg",
        
        60: "I-6_32.jpg",
        61: "I-6_34.jpg",
        62: "I-6_36.jpg",
        63: "I-6_35.jpg",
    ]
    
    static var commentImgOffset:CGFloat = 10
    
    let seriesIndex2TipsComments:[Int:(tipsImg: CGPoint, tipsLine: CGPoint, tipsBtn:CGPoint, commentsImg:CGPoint, commentsLine:CGPoint, commentsBtn:CGPoint)] = {
        var ret:[Int:(tipsImg: CGPoint, tipsLine: CGPoint, tipsBtn:CGPoint, commentsImg:CGPoint, commentsLine:CGPoint, commentsBtn:CGPoint)] = [:]
        
        let tc10 = (tipsImg: CGPoint(x:673, y: 425 - IxxVC.commentImgOffset), tipsLine: CGPoint(x:622, y:432), tipsBtn:CGPoint(x:632, y:415), commentsImg:CGPoint(x:667, y:537 - IxxVC.commentImgOffset), commentsLine:CGPoint(x:610, y:544), commentsBtn:CGPoint(x:622, y:527))
        let tc11 = (tipsImg: CGPoint(x:673, y: 425 - IxxVC.commentImgOffset), tipsLine: CGPoint(x:622, y:432), tipsBtn:CGPoint(x:632, y:415), commentsImg:CGPoint(x:667, y:537 - IxxVC.commentImgOffset), commentsLine:CGPoint(x:610, y:544), commentsBtn:CGPoint(x:622, y:527))
        let tc12 = (tipsImg: CGPoint(x:673, y: 425 - IxxVC.commentImgOffset), tipsLine: CGPoint(x:622, y:432), tipsBtn:CGPoint(x:632, y:415), commentsImg:CGPoint(x:667, y:537 - IxxVC.commentImgOffset), commentsLine:CGPoint(x:610, y:544), commentsBtn:CGPoint(x:622, y:527))
        let tc13 = (tipsImg: CGPoint(x:643, y: 425 - IxxVC.commentImgOffset), tipsLine: CGPoint(x:592, y:432), tipsBtn:CGPoint(x:602, y:415), commentsImg:CGPoint(x:637, y:537 - IxxVC.commentImgOffset), commentsLine:CGPoint(x:580, y:544), commentsBtn:CGPoint(x:592, y:527))
        
        ret[10] = tc10
        ret[11] = tc11
        ret[12] = tc12
        ret[13] = tc13
        
        let tc20 = (tipsImg: CGPoint(x:673, y: 425 - IxxVC.commentImgOffset), tipsLine: CGPoint(x:622, y:432), tipsBtn:CGPoint(x:632, y:415), commentsImg:CGPoint(x:667, y:537 - IxxVC.commentImgOffset), commentsLine:CGPoint(x:610, y:544), commentsBtn:CGPoint(x:622, y:527))
        let tc21 = (tipsImg: CGPoint(x:673, y: 425 - IxxVC.commentImgOffset), tipsLine: CGPoint(x:622, y:432), tipsBtn:CGPoint(x:632, y:415), commentsImg:CGPoint(x:667, y:537 - IxxVC.commentImgOffset), commentsLine:CGPoint(x:610, y:544), commentsBtn:CGPoint(x:622, y:527))
        let tc22 = (tipsImg: CGPoint(x:673, y: 425 - IxxVC.commentImgOffset), tipsLine: CGPoint(x:622, y:432), tipsBtn:CGPoint(x:632, y:415), commentsImg:CGPoint(x:667, y:537 - IxxVC.commentImgOffset), commentsLine:CGPoint(x:610, y:544), commentsBtn:CGPoint(x:622, y:527))
        let tc23 = (tipsImg: CGPoint(x:643, y: 425 - IxxVC.commentImgOffset), tipsLine: CGPoint(x:592, y:432), tipsBtn:CGPoint(x:602, y:415), commentsImg:CGPoint(x:637, y:537 - IxxVC.commentImgOffset), commentsLine:CGPoint(x:580, y:544), commentsBtn:CGPoint(x:592, y:527))
        
        ret[20] = tc20
        ret[21] = tc21
        ret[22] = tc22
        ret[23] = tc23
        
        let tc30 = (tipsImg: CGPoint(x:673, y: 425 - IxxVC.commentImgOffset), tipsLine: CGPoint(x:622, y:432), tipsBtn:CGPoint(x:632, y:415), commentsImg:CGPoint(x:667, y:537 - IxxVC.commentImgOffset), commentsLine:CGPoint(x:610, y:544), commentsBtn:CGPoint(x:622, y:527))
        let tc31 = (tipsImg: CGPoint(x:683, y: 425 - IxxVC.commentImgOffset), tipsLine: CGPoint(x:632, y:432), tipsBtn:CGPoint(x:642, y:415), commentsImg:CGPoint(x:687, y:537 - IxxVC.commentImgOffset), commentsLine:CGPoint(x:620, y:544), commentsBtn:CGPoint(x:632, y:527))
        let tc32 = (tipsImg: CGPoint(x:673, y: 425 - IxxVC.commentImgOffset), tipsLine: CGPoint(x:622, y:432), tipsBtn:CGPoint(x:632, y:415), commentsImg:CGPoint(x:667, y:537 - IxxVC.commentImgOffset), commentsLine:CGPoint(x:610, y:544), commentsBtn:CGPoint(x:622, y:527))
        let tc33 = (tipsImg: CGPoint(x:673, y: 425 - IxxVC.commentImgOffset), tipsLine: CGPoint(x:622, y:432), tipsBtn:CGPoint(x:632, y:415), commentsImg:CGPoint(x:667, y:537 - IxxVC.commentImgOffset), commentsLine:CGPoint(x:610, y:544), commentsBtn:CGPoint(x:622, y:527))
        
        ret[30] = tc30
        ret[31] = tc31
        ret[32] = tc32
        ret[33] = tc33
        
        let tc40 = (tipsImg: CGPoint(x:673, y: 425 - IxxVC.commentImgOffset), tipsLine: CGPoint(x:622, y:432), tipsBtn:CGPoint(x:632, y:415), commentsImg:CGPoint(x:667, y:537 - IxxVC.commentImgOffset), commentsLine:CGPoint(x:610, y:544), commentsBtn:CGPoint(x:622, y:527))
        let tc41 = (tipsImg: CGPoint(x:643, y: 425 - IxxVC.commentImgOffset), tipsLine: CGPoint(x:592, y:432), tipsBtn:CGPoint(x:602, y:415), commentsImg:CGPoint(x:637, y:537 - IxxVC.commentImgOffset), commentsLine:CGPoint(x:580, y:544), commentsBtn:CGPoint(x:592, y:527))
        
        ret[40] = tc40
        ret[41] = tc41
        
        
        let tc50 = (tipsImg: CGPoint(x:673, y: 425 - IxxVC.commentImgOffset), tipsLine: CGPoint(x:622, y:432), tipsBtn:CGPoint(x:632, y:415), commentsImg:CGPoint(x:667, y:537 - IxxVC.commentImgOffset), commentsLine:CGPoint(x:610, y:544), commentsBtn:CGPoint(x:622, y:527))
        let tc51 = (tipsImg: CGPoint(x:683, y: 425 - IxxVC.commentImgOffset), tipsLine: CGPoint(x:632, y:432), tipsBtn:CGPoint(x:642, y:415), commentsImg:CGPoint(x:687, y:537 - IxxVC.commentImgOffset), commentsLine:CGPoint(x:620, y:544), commentsBtn:CGPoint(x:632, y:527))
        let tc52 = (tipsImg: CGPoint(x:643, y: 425 - IxxVC.commentImgOffset), tipsLine: CGPoint(x:592, y:432), tipsBtn:CGPoint(x:602, y:415), commentsImg:CGPoint(x:637, y:537 - IxxVC.commentImgOffset), commentsLine:CGPoint(x:580, y:544), commentsBtn:CGPoint(x:592, y:527))
        
        ret[50] = tc50
        ret[51] = tc51
        ret[52] = tc52
        
        
        let tc60 = (tipsImg: CGPoint(x:673, y: 425 - IxxVC.commentImgOffset), tipsLine: CGPoint(x:622, y:432), tipsBtn:CGPoint(x:632, y:415), commentsImg:CGPoint(x:667, y:537 - IxxVC.commentImgOffset), commentsLine:CGPoint(x:610, y:544), commentsBtn:CGPoint(x:622, y:527))
        let tc61 = (tipsImg: CGPoint(x:673, y: 425 - IxxVC.commentImgOffset), tipsLine: CGPoint(x:622, y:432), tipsBtn:CGPoint(x:632, y:415), commentsImg:CGPoint(x:667, y:537 - IxxVC.commentImgOffset), commentsLine:CGPoint(x:610, y:544), commentsBtn:CGPoint(x:622, y:527))
        let tc62 = (tipsImg: CGPoint(x:683, y: 425 - IxxVC.commentImgOffset), tipsLine: CGPoint(x:632, y:432), tipsBtn:CGPoint(x:642, y:415), commentsImg:CGPoint(x:687, y:537 - IxxVC.commentImgOffset), commentsLine:CGPoint(x:620, y:544), commentsBtn:CGPoint(x:632, y:527))
        let tc63 = (tipsImg: CGPoint(x:643, y: 425 - IxxVC.commentImgOffset), tipsLine: CGPoint(x:592, y:432), tipsBtn:CGPoint(x:602, y:415), commentsImg:CGPoint(x:637, y:537 - IxxVC.commentImgOffset), commentsLine:CGPoint(x:580, y:544), commentsBtn:CGPoint(x:592, y:527))
        
        ret[60] = tc60
        ret[61] = tc61
        ret[62] = tc62
        ret[63] = tc63
        
        return ret
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.imgView.image = UIImage(named: seriesIndex2Img[series * 10 + index]!, cached:false)
        self.tipsBtn.origin = seriesIndex2TipsComments[series * 10 + index]!.tipsBtn
        self.tipsImg.origin = seriesIndex2TipsComments[series * 10 + index]!.tipsImg
        self.tipsLine.origin = seriesIndex2TipsComments[series * 10 + index]!.tipsLine
        
        self.commentsBtn.origin = seriesIndex2TipsComments[series * 10 + index]!.commentsBtn
        self.commentsImg.origin = seriesIndex2TipsComments[series * 10 + index]!.commentsImg
        self.commentsLine.origin = seriesIndex2TipsComments[series * 10 + index]!.commentsLine
        
        self.closeBtn.isExclusiveTouch = true
        self.closeBtn.addTarget(.touchUpInside) { 
            [unowned self] in
            Analytics.sharedInstance.appendPageCodeCount(with: "Ix_\(self.series!)", isHuman: true)
            let _ = self.navigationController?.popViewController(animated: true)
        }
        
        self.otherBtn.isExclusiveTouch = true
        self.otherBtn.addTarget(.touchUpInside) {
            [unowned self] in
            
            if let vcs = self.navigationController?.viewControllers {
                for vc in vcs {
                    if vc is H1VC {
                        Analytics.sharedInstance.appendPageCodeCount(with: "H1", isHuman: true)
                        let _ = self.navigationController?.popToViewController(vc, animated: true)
                        break
                    }
                }
            }
        }
        
        
        self.tipsBtn.isExclusiveTouch = true
        self.tipsBtn.addTarget(.touchUpInside) {
            [unowned self] in
            let vc = IxyVC.instantiateFromStoryboard()
            vc.series = self.series
            vc.index = self.index
            Analytics.sharedInstance.appendPageCodeCount(with: "Ixy_\(vc.series!)_\(vc.index!)", isHuman: true)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        self.commentsBtn.isExclusiveTouch = true
        self.commentsBtn.addTarget(.touchUpInside) { 
            [unowned self] in
            let vc = IxzVC.instantiateFromStoryboard()
            vc.series = self.series
            vc.index = self.index
            Analytics.sharedInstance.appendPageCodeCount(with: "Ixz_\(vc.series!)_\(vc.index!)", isHuman: true)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        startToRootViewControllerCountDown()
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
