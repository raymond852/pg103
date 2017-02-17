//
//  Analytics.swift
//  pg
//
//  Created by hy110831 on 8/24/16.
//  Copyright © 2016 hy110831. All rights reserved.
//

import Foundation
import KeychainAccess

class Analytics:NSObject {
    
    var sessionStarted:Bool = false
    
    var gender:String?
    var duration:Int?
    var t:Int = 0
    
    var level1PickupTimesDict:[String:Int]?
    var pageCodeTimesDict: [String:(human:Int, nothuman:Int)]?
    
    lazy var sessionQueue: DispatchQueue = DispatchQueue(label: "Analytics")

    lazy var isWeightUpdateDebouncing:[Int:Bool] = [:]
    
    func startSession() {
        sessionQueue.async { [unowned self] in
            if (!self.sessionStarted) {
                Logger.debug("Analytics: session started")
                self.t = Int(Date().timeIntervalSince1970)
                self.sessionStarted = true
            }
        }
        
    }
    
    func endSession() {
        sessionQueue.async { 
            [unowned self] in
            guard self.sessionStarted == true else {
                return
            }
            var params:[String:Any] = ["t": self.t]
            if let gender = self.gender {
                params["gender"] = gender
            }
            if let duration = self.duration {
                params["duration"] = duration
            }
            if let level1Dict = self.level1PickupTimesDict {
                params.merge(level1Dict)
            }
            if let pageCodeDict = self.pageCodeTimesDict {
                var finalDic:[String:Any] = [:]
                for (key, value) in pageCodeDict {
                    finalDic[key] = ["human": value.human, "nothuman": value.nothuman]
                }
                params.merge(finalDic)
            }
            let _ = HTTPHelper.sharedInstance.uploadAnalytics(with: params)
            self.sessionStarted = false
            self.level1PickupTimesDict = nil
            self.pageCodeTimesDict = nil
            self.t = 0
            self.gender = nil
            self.duration = nil
        }
    }
    
    func appendLevel1ItemVal(id:Int) {
        sessionQueue.async { [unowned self] in
            if (!self.sessionStarted) {
                Logger.error("session not started")
            }
            if self.level1PickupTimesDict == nil {
                self.level1PickupTimesDict = [:]
            }
            
            if let count = self.level1PickupTimesDict?[String(id)] {
                self.level1PickupTimesDict?[String(id)] = count + 1
            } else {
                self.level1PickupTimesDict?[String(id)] = 1
            }
        }
    }
    
    func appendPageCodeCount(with pageCode:String, isHuman:Bool) {
        sessionQueue.async {
            [unowned self] in
            if (!self.sessionStarted) {
                Logger.error("session not started")
            }
            if self.pageCodeTimesDict == nil {
                self.pageCodeTimesDict = [:]
            }
            
            if let data = self.pageCodeTimesDict?[pageCode] {
                let humanCount = data.human
                let nothumanCount = data.nothuman
                if isHuman {
                    self.pageCodeTimesDict![pageCode] = (human: humanCount + 1, nothuman: nothumanCount)
                } else {
                    self.pageCodeTimesDict![pageCode] = (human: humanCount, nothuman: nothumanCount + 1)
                }
            } else {
                if isHuman {
                    self.pageCodeTimesDict?[pageCode] = (human: 1, nothuman: 0)
                } else {
                    self.pageCodeTimesDict?[pageCode] = (human: 0, nothuman: 1)
                }
            }
        }
    }
    
    func updateWeightByLevelWithDebounce(timeInterval:TimeInterval, level:Int) {
        if self.isWeightUpdateDebouncing[level] == true {
            return
        }
        self.isWeightUpdateDebouncing[level] = true
        var value = "0-0-0-0-0-0-0-0"
        switch level {
        case 2:
            value = ItemPickupDectection.shared.level2WeightHexStr
            break
        case 3:
            value = ItemPickupDectection.shared.level3WeightHexStr
            break
        case 4:
            value = ItemPickupDectection.shared.level4WeightHexStr
            break
        default:
            break
        }
        DispatchQueue.global().asyncAfter(deadline: .now() + timeInterval) { [unowned self] in
            self.isWeightUpdateDebouncing[level] = false
            let _ = HTTPHelper.sharedInstance.uploadWeight(with: [
                "level": level, "value": value])
        }
        
    }
    
    

    // MARK: Singleton
    fileprivate override init() {
        super.init()
    }
    
    
    static var sharedInstance = Analytics()
    
}
