//
//  IxzVC.swift
//  pg102
//
//  Created by hy110831 on 1/16/17.
//  Copyright © 2017 hy110831. All rights reserved.
//

import UIKit
import JavaScriptCore

class IxzVC: BaseViewController {

    @IBOutlet weak var closeBtn:UIImageView!
    @IBOutlet weak var webView:UIWebView!
    
    var series:Int!
    var index:Int!
    
    let TMALL_SELLER_ID = "1943402959"
    
    var seriesIndex2TmallProductId:[Int: String] = [
        10: "36940537022",
        11: "36940537022",
        13: "542358247871",
        12: "542351626047",
        
        20: "41701448227",
        21: "41701448227",
        22: "542351626047",
        23: "542358247871",
        
        30: "41778204635",
        31: "41778204635",
        32: "542351626047",
        33: "542358247871",
        
        40: "36817740554",
        41: "542358247871",
        
        50: "37387855564",
        51: "37387855564",
        52: "542358247871",
        
        60: "532962396708",
        61: "36801794303",
        62: "38676077582",
        63: "542358247871"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let context = webView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") {
            let _ = (context as AnyObject).evaluateScript("var console = { log: function(message) { _consoleLog(message) } }")
            let consoleLog: @convention(block) (String) -> Void = { message in
                Logger.info("javascript_log: " + message)
            }
            (context as AnyObject).setObject(unsafeBitCast(consoleLog, to: AnyObject.self), forKeyedSubscript: "_consoleLog" as (NSCopying & NSObjectProtocol)!)
        }
        
        let relativeUrl = URL(fileURLWithPath: Bundle.main.bundlePath)
        let commentPageUrl = URL(string: "tmall_comments.html?" + "sellerId=\(TMALL_SELLER_ID)" + "&itemId=\(seriesIndex2TmallProductId[series * 10 + index]!)", relativeTo: relativeUrl)!
        
        let req = URLRequest(url:commentPageUrl)
        self.webView.loadRequest(req)
        
        self.closeBtn.isUserInteractionEnabled = true
        self.closeBtn.isExclusiveTouch = true
        self.closeBtn.addSingleTapGestureRecognizerWithResponder { [unowned self] (tap) in
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
