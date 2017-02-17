//
//  SwiftyJSONExt.swift
//  XFBConsumer
//
//  Created by hy110831 on 4/12/16.
//  Copyright © 2016 hy110831. All rights reserved.
//

import Foundation
import SwiftyJSON

extension JSON {
    
    func parseFloat()->Float? {
        if let val = self.string {
            return Float(val)
        } else {
            return self.float
        }
    }
    
    func parseInt()->Int? {
        if let id = self.string {
            return Int(id)
        } else {
            return self.int
        }
    }
    
    func parseString()->String? {
        if let id = self.number {
            return id.stringValue
        } else {
            return self.string
        }
    }
    
    func parseDateRFC3999()->Date? {
        if let dateStr = self.string {
            return rfc3999DateFormatter.date(from: dateStr)
        }
        return nil
    }
    
    func parseDateUnixTime()->Date? {
        if let dateStr = self.string {
            if let dateDouble = Double(dateStr) {
                return Date(timeIntervalSince1970: dateDouble)
            }
        } else if let dateNumber = self.number {
            return Date(timeIntervalSince1970: dateNumber.doubleValue)
        }
        return nil
    }
    
    func parseBool()->Bool {
        if let dataStr = self.string {
            if dataStr == "y" {
                return true
            }
        }
        return false
    }
    
    func isHttpOk()->Bool {
        if let statusCode = self["_statusCode"].int {
            if statusCode == 200 || statusCode == 201 {
                return true
            }
        }
        return false
    }
    
    func nonEmptyString()->String? {
        if (self.string ?? "").trim().isEmpty {
            return nil
        }
        return self.string
    }
    
    func parseDate(_ dateFormatter:DateFormatter)->Date? {
        if let string = self.string {
            return dateFormatter.date(from: string)
        }
        return nil
    }
//    
//    func populateListFromJSON<Type:ApiData>(_ validator:((Type)-> Bool)? = nil)->[Type] {
//        var ret:[Type] = []
//        for (_, dataJson):(String, JSON) in self {
//            let obj = Type(json:dataJson)
//            if let validFunc = validator {
//                if validFunc(obj) {
//                    ret.append(obj)
//                }
//            } else {
//                ret.append(obj)
//            }
//        }
//        return ret
// 
//    }
}


