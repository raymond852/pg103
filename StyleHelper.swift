//
//  StyleHelper.swift
//  pg
//
//  Created by hy110831 on 8/21/16.
//  Copyright © 2016 hy110831. All rights reserved.
//

import Foundation
import UIKit

class StyleHelper {
    
    static var buttonColor = UIColor(red: 253/255, green: 131/255, blue: 135/255, alpha: 1)
    
    static var buttonUnselectedColor = UIColor(red: 252/255, green: 174/255, blue: 177/255, alpha: 1)
    
    static var buttonShadowColor = StyleHelper.buttonColor.withAlphaComponent(0.7)
    
    static var buttonUnselectedShadowColor = StyleHelper.buttonUnselectedColor.withAlphaComponent(0.7)
    
    static func showToast(with message:String) {
       // UIApplication.shared.keyWindow?.makeToast(message)
    }
    
    // MARK: - Alert
    static func showErrorAlertWithTitle(_ title:String, doneText: String = "确定", doneCallback: ((Void)->())? = nil) {
//        let alert = FCAlertView()
//        alert.makeAlertTypeWarning()
//        alert.doneActionBlock { [unowned alert] in
//            if let callback = doneCallback {
//                callback()
//            }
//            alert.dismiss()
//        }
//        alert.showAlert(withTitle: nil, withSubtitle: title, withCustomImage: nil, withDoneButtonTitle: doneText, andButtons: nil)
        
    }
}
