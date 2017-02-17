//
//  B1VC.swift
//  pg
//
//  Created by hy110831 on 8/14/16.
//  Copyright © 2016 hy110831. All rights reserved.
//

import UIKit
import AVFoundation
import pop
import SnapKit


class B1VC: BaseViewController {
    
    let DURATION_END_VIDEO:Float64 = 13
    
    var avPlayer: AVPlayer!
    var videoView:VideoPlayerView!
    var learnMoreButton: UIButton!
    var handImg:UIImageView!
    var actionLabel:UILabel!
    var genderLabel:UILabel!
    var timeObserver: AnyObject?
    
    var once_token:Int = 0
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.isHidden = true
        super.viewDidLoad()
        view.backgroundColor = .black
        
        
        let url = URL(fileURLWithPath: Bundle.main.path(forResource: "/SrcVideo/B1_video" , ofType:"mp4")!)
        let playerItem = AVPlayerItem(url: url)
        
        avPlayer = AVPlayer(playerItem: playerItem)
        avPlayer.volume = 1.0
        videoView = VideoPlayerView()
        self.view.addSubview(videoView)
        videoView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        if let layer = videoView.layer as? AVPlayerLayer {
            layer.player = avPlayer
        }
        
        
        let anim = POPBasicAnimation(propertyNamed: kPOPViewScaleXY)
        anim?.toValue = NSValue(cgSize: CGSize(width: 1.5, height: 1.5))
        anim?.autoreverses = true
        anim?.repeatForever = true
        
        let timeInterval: CMTime = CMTimeMakeWithSeconds(0.5, 10)
        timeObserver = avPlayer.addPeriodicTimeObserver(forInterval: timeInterval, queue: DispatchQueue.main) { [weak self] (elapsedTime: CMTime) -> Void in
            if self?.avPlayer.currentItem == nil {
                return
            }
            
            let elapsedTime = CMTimeGetSeconds(elapsedTime)
            if let endTime = self?.DURATION_END_VIDEO {
                if elapsedTime >= endTime {
                    self?.goToE1VC()
                }
            }
        } as AnyObject!
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 7) { 
            [weak self] in
            self?.showLearnMore()
        }
        
        let btn = UIButton()
        let image = UIImage(named: "ic_b1_rect.png", cached: true)
        btn.setImage(image, for: UIControlState.normal)
        btn.frame = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.width)
        btn.right = self.view.width - 30
        btn.top = 22 + 30
        self.view.addSubview(btn)
        btn.isHidden = true
        btn.addTarget(.touchUpInside) { 
            [weak self] in
            if let strongSelf = self {
                guard strongSelf.actionLabel.isHidden == false && strongSelf.genderLabel.isHidden == false else {
                    return
                }
                if let timeObserver = strongSelf.timeObserver {
                    strongSelf.avPlayer.removeTimeObserver(timeObserver)
                    strongSelf.timeObserver = nil
                }
                Analytics.sharedInstance.appendPageCodeCount(with: "E1", isHuman: true)
                self?.navigationController?.setViewControllers([E1VC.instantiateFromStoryboard()], animated: true)
            }
        }
        learnMoreButton = btn
        
        var label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 180, height: 20)
        label.left = 10
        label.top = learnMoreButton.height / 2 + 12
        label.font = UIFont.systemFont(ofSize: 32)
        label.textColor = UIColor.white
        label.text = "立即型动"
        label.isHidden = true
        learnMoreButton.addSubview(label)
        actionLabel = label
        
        label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 100, height: 20)
        label.left = 10
        label.bottom = learnMoreButton.height / 2 - 12
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textColor = UIColor.white
        label.text = "女神！"
        label.isHidden = true
        learnMoreButton.addSubview(label)
        genderLabel = label
        
        handImg = UIImageView()
        let img = UIImage(named: "ic_hand_big.png", cached: false)
        handImg.image = img
        handImg.frame = CGRect(x: 0, y: 0, width: img.size.width * 0.8, height: img.size.height * 0.8)
        self.view.addSubview(handImg)
        handImg.right = learnMoreButton.right - 20
        handImg.top = learnMoreButton.bottom - 50
        handImg.isHidden = true
        handImg.isUserInteractionEnabled = true
        handImg.isExclusiveTouch = true
        handImg.addSingleTapGestureRecognizerWithResponder { [weak self] (tap) in
            if let strongSelf = self {
                guard strongSelf.actionLabel.isHidden == false && strongSelf.genderLabel.isHidden == false else {
                    return
                }
                if let timeObserver = strongSelf.timeObserver {
                    strongSelf.avPlayer.removeTimeObserver(timeObserver)
                    strongSelf.timeObserver = nil
                }
                Analytics.sharedInstance.appendPageCodeCount(with: "E1", isHuman: true)
                self?.navigationController?.setViewControllers([E1VC.instantiateFromStoryboard()], animated: true)
            }
            
        }

    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    deinit {
        if let timeObserver = self.timeObserver {
            self.avPlayer.removeTimeObserver(timeObserver)
            self.timeObserver = nil
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        avPlayer.play()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    
    // Force the view into landscape mode (which is how most video media is consumed.)
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.landscape
    }
    
    fileprivate func showLearnMore() {
        learnMoreButton.isHidden = false
        let strongSelf = self
                let label = strongSelf.genderLabel
                if FaceDectection.sharedInstance.faceModel?.gender == .male {
                    label?.text = "男神！"
                    label?.isHidden = false
                }
                else {
                    label?.text = "女神！"
                    label?.isHidden = false
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    [weak self] in
                    self?.actionLabel.isHidden = false
                    let anim = POPBasicAnimation(propertyNamed: kPOPViewScaleXY)
                    anim?.toValue = NSValue(cgSize: CGSize(width: 1.5, height: 1.5))
                    anim?.autoreverses = true
                    anim?.repeatForever = true
                    
                    self?.handImg.pop_add(anim, forKey: "scale")
                    self?.handImg.isHidden = false
                })
    }
    
}


extension B1VC {
    
    func goToE1VC() {
        if let interactNavVC = self.navigationController  {
            Analytics.sharedInstance.appendPageCodeCount(with: "E1", isHuman: false)
            interactNavVC.setViewControllers([E1VC.instantiateFromStoryboard()], animated: true)
        }
    }
    
}
