//
//  CxVC.swift
//  pg102
//
//  Created by hy110831 on 1/13/17.
//  Copyright © 2017 hy110831. All rights reserved.
//

import UIKit

class CxVC: BaseViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView:UIScrollView!
    
    var imageView:UIImageViewAligned!
    
    var imageName:String!

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.bounces = false
        scrollView.alwaysBounceVertical = false
        
        imageView = UIImageViewAligned()
        imageView.frame = CGRect(x: 0, y: 0, width: scrollView.frame.size.width, height: scrollView.frame.size.height)
        
        let imagee = UIImage(named: imageName, cached: false)
        
        imageView.image = imagee
        
        let contentSize = CGSize(width: scrollView.frame.size.width, height: imagee.size.height / imagee.size.width * scrollView.frame.size.width)

        imageView.contentMode = .scaleAspectFill
        imageView.alignTop = true
        scrollView.addSubview(imageView)
        
        scrollView.contentSize = contentSize
       
        let closeBtn = UIButton(frame: CGRect(x: 935, y: 49, width: 45, height:45))
        closeBtn.setImage(UIImage(named: "close.png", cached: true), for: UIControlState.normal)
        self.view.addSubview(closeBtn)
        closeBtn.isExclusiveTouch = true
        closeBtn.addTarget(.touchUpInside) {
            [unowned self] in
            let _ = self.navigationController?.popViewController(animated: true)
        }
        
        startToRootViewControllerCountDown()
    }
    
    func startToRootViewControllerCountDown() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 15, execute: { [weak self] in
            if let navigationController = self?.navigationController as? InteractNavVC {
                if navigationController.fireInteractTimestamp > Date().timeIntervalSince1970 {
                    self?.startToRootViewControllerCountDown()
                } else {
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
