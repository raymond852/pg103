//
//  G1VC.swift
//  pg102
//
//  Created by hy110831 on 1/16/17.
//  Copyright © 2017 hy110831. All rights reserved.
//

import UIKit

class G1VC: BaseViewController {

    @IBOutlet weak var imgView:UIImageView!
    @IBOutlet weak var closeBtn:UIButton!
    @IBOutlet weak var openRedPocketBtn:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        closeBtn.addTarget(.touchUpInside) { 
            [unowned self] in
            Analytics.sharedInstance.appendPageCodeCount(with: "E1", isHuman: true)
            let _ = self.navigationController?.popViewController(animated: true)
        }
        openRedPocketBtn.addTarget(.touchUpInside) { 
            [unowned self] in
            Analytics.sharedInstance.appendPageCodeCount(with: "G2", isHuman: true)
            let vc = G2VC.instantiateFromStoryboard()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        startToRootViewControllerCountDown()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
