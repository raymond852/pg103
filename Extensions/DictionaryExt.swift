//
//  DictionaryExt.swift
//  XFBConsumer
//
//  Created by hy110831 on 4/2/16.
//  Copyright © 2016 hy110831. All rights reserved.
//

import Foundation

extension Dictionary {
    mutating func merge(_ other:Dictionary?) {
        if other != nil {
            for (key,value) in other! {
                self.updateValue(value, forKey:key)
            }
        }
    }
    
    func stringFromHttpParameters() -> String {
        let parameterArray = self.map { (key, value) -> String in
            let percentEscapedKey = (key as! String).stringByAddingPercentEncodingForURLQueryValue()!
            var finalVal:String!
            if let val = value as? Int {
                finalVal = String(val)
            } else if let val = value as? Int64 {
                finalVal = String(val)
            } else if let val = value as? Float {
                finalVal = String(val)
            } else {
                finalVal = value as! String
            }
            let percentEscapedValue = finalVal!.stringByAddingPercentEncodingForURLQueryValue()!
            return "\(percentEscapedKey)=\(percentEscapedValue)"
        }
        
        return parameterArray.joined(separator: "&")
    }
}
