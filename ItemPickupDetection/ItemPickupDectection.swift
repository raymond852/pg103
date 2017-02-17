//
//  ItemPickupDectection.swift
//  pg
//
//  Created by hy110831 on 8/23/16.
//  Copyright © 2016 hy110831. All rights reserved.
//

import Foundation

enum ItemState:Int {
    case initial = 0
    case pickup = 1
    case drop = 2
}

class ItemPickupDectection:NSObject {
    
    static let NOTIF_ITEM_PICKUP_DETECTION = "ItemPickupDectectionStateChanged"
    static let KEY_LEVEL_CHANGE = "ITEM_LEVEL"
    static let KEY_LEVEL_STATE = "LEVEL_STATE"
    
    let LEVEL1_THRESHOLD:Double = 10
    let OHTER_LEVEL_THRESHOLD:Double = 2
    let INVALID_READ_VALUE:Double = -1
    let BUF_SIZE = 1
    
    lazy var level1:[Int: (buffer:[Double], state:ItemState)] = [:]
    lazy var otherLevels:[(buffer:[Double], state:ItemState)] = []
    
    var thread:Thread?
    var timer:Timer?
    
    lazy var level2WeightHexStr:String = "0-0-0-0-0-0-0-0"
    lazy var level3WeightHexStr:String = "0-0-0-0-0-0-0-0"
    lazy var level4WeightHexStr:String = "0-0-0-0-0-0-0-0"
    
    func startRunning() {
        if #available(iOS 10.0, *) {
            thread = Thread(target: self, selector: #selector(startPeriodicalRead), object: nil)
            thread?.start()
        } else {
            // Fallback on earlier versions
        }
    }
    
    func stopRunning() {
        guard let timer = self.timer else {
            return
        }
        timer.invalidate()
        self.timer = nil
        guard let thread = self.thread else {
            return
        }
        thread.cancel()
        self
            .thread = nil
    }
    
    func startPeriodicalRead() {
        if #available(iOS 10.0, *) {
            self.timer = Timer.scheduledTimer(withTimeInterval: 60 * 15, repeats: true) { (timer) in
                DispatchQueue.global().asyncAfter(deadline: .now(), execute: {
                    CC2541.shared.readLevel(level: 4)
                })
                DispatchQueue.global().asyncAfter(deadline: .now() + 5, execute: {
                    CC2541.shared.readLevel(level: 2)
                })
                DispatchQueue.global().asyncAfter(deadline: .now() + 5, execute: {
                    CC2541.shared.readLevel(level: 3)
                })
            }
            RunLoop.current.run()
        } else {
            // Fallback on earlier versions
        }
    }
    
    func feedData(_ data:Data, level:Int) {
        if level == 1 {
            let valStr = data.hexEncodedString()
            // Level 1 values
            var vals:[UInt16] = [UInt16(valStr[0...1], radix: 16)!, UInt16(valStr[4...5], radix: 16)!, UInt16(valStr[8...9], radix: 16)!, UInt16(valStr[16...17], radix: 16)!, UInt16(valStr[20...21], radix: 16)!].map({ (value:UInt16) -> UInt16 in
                if value == 0xff {
                    return 0
                }
                return value
            })
            
            for i in 1...5 {
                
                var metaData = level1[i]!
                let val = Double(vals[i - 1])
                if metaData.buffer.count < BUF_SIZE {
                    metaData.buffer.append(val)
                } else {
                    let average:Double = metaData.buffer[0 ..< metaData.buffer.count].reduce(0) {
                        return Double($0) + Double($1) / Double(metaData.buffer.count)
                    }
                    if average - val > LEVEL1_THRESHOLD {
                        metaData.buffer.append(val)
                        metaData.buffer = Array(metaData.buffer[1 ..< metaData.buffer.count])
                        metaData.state = .pickup
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(name: NSNotification.Name(ItemPickupDectection.NOTIF_ITEM_PICKUP_DETECTION), object: self, userInfo: [ItemPickupDectection.KEY_LEVEL_CHANGE: 10 + i, ItemPickupDectection.KEY_LEVEL_STATE: ItemState.pickup])
                            StyleHelper.showToast(with: "Level \(10 + i) Pick Up")
                            Logger.info("Level \(10 + i) Pick up")
                        }
                    } else if val - average > LEVEL1_THRESHOLD {
                        metaData.buffer.append(val)
                        metaData.buffer = Array(metaData.buffer[1 ..< metaData.buffer.count])
                        metaData.state = .drop
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(name: NSNotification.Name(ItemPickupDectection.NOTIF_ITEM_PICKUP_DETECTION), object: self, userInfo: [ItemPickupDectection.KEY_LEVEL_CHANGE: 10 + i, ItemPickupDectection.KEY_LEVEL_STATE: ItemState.drop])
                            StyleHelper.showToast(with: "Level \(10 + i) Drop")
                            Logger.info("Level \(10 + i) Drop")
                        }
                    } else {
                        metaData.buffer.append(val)
                        metaData.buffer = Array(metaData.buffer[1 ..< metaData.buffer.count])
                    }
                    
                    if abs(average - val) > 0.5 {
                        Logger.info("Level \(10 + i) average:\(average) current:\(val) buf:\(metaData)")
                    }
                }
                level1[i]! = metaData
                
            }
//            Logger.info("Level 1: \(vals)")
            
            return
        }
        
        let valStr = data.hexEncodedString()
        var val2Upload:String = ""
        var total:Int = 0
        for i in  0 ..< 8 {
            let start = 4 * i
            let end = 4 * i + 1
            var read = UInt16(valStr[start...end], radix: 16)!
            if read == 255 {
                read = 0
            }
            val2Upload += "\(read)"
            if i != 7 {
                val2Upload += "-"
            }
            total += Int(read)
        }
        switch level {
        case 3:
            level3WeightHexStr = val2Upload
            break
        case 4:
            level4WeightHexStr = val2Upload
            break
        default:
            level2WeightHexStr = val2Upload
            break
        }
        
        let val = Double(total)
        var metaData = otherLevels[level - 2]
        if metaData.buffer.count < BUF_SIZE {
            metaData.buffer.append(val)
        } else {
            let average:Double = metaData.buffer.reduce(0) {
                return Double($0) + Double($1) / Double(metaData.buffer.count)
            }
            if average - val > OHTER_LEVEL_THRESHOLD {
                metaData.buffer.append(val)
                metaData.buffer = Array(metaData.buffer[1 ..< metaData.buffer.count])
                metaData.state = .pickup
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: NSNotification.Name(ItemPickupDectection.NOTIF_ITEM_PICKUP_DETECTION), object: self, userInfo: [ItemPickupDectection.KEY_LEVEL_CHANGE: level, ItemPickupDectection.KEY_LEVEL_STATE: ItemState.pickup])
                    StyleHelper.showToast(with: "Level \(level) Pick Up")
                    Logger.info("Level \(level) Pick up")
                    CC2541.shared.lightOnLed(withLevel: level)
                }
            } else if val - average > OHTER_LEVEL_THRESHOLD {
                metaData.buffer.append(val)
                metaData.buffer = Array(metaData.buffer[1 ..< metaData.buffer.count])
                metaData.state = .drop
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: NSNotification.Name(ItemPickupDectection.NOTIF_ITEM_PICKUP_DETECTION), object: self, userInfo: [ItemPickupDectection.KEY_LEVEL_CHANGE: level, ItemPickupDectection.KEY_LEVEL_STATE: ItemState.drop])
                    StyleHelper.showToast(with: "Level \(level) Drop")
                    Logger.info("Level \(level) Drop")
                }
            } else {
                metaData.buffer.append(val)
                metaData.buffer = Array(metaData.buffer[1 ..< metaData.buffer.count])
            }
            
//            if abs(average - val) > 0.5 {
//                Logger.info("Level \(level) average:\(average) current:\(val) buf:\(metaData)")
//            }
        }
        otherLevels[level - 2] = metaData
        
    }
    
    
    // MARK: Singleton
    fileprivate override init() {
        super.init()
        level1[1] = (buffer: [], state:.initial)
        level1[2] = (buffer: [], state:.initial)
        level1[3] = (buffer: [], state:.initial)
        level1[4] = (buffer: [], state:.initial)
        level1[5] = (buffer: [], state:.initial)
        
        otherLevels.append((buffer:[], state:.initial))
        otherLevels.append((buffer:[], state:.initial))
        otherLevels.append((buffer:[], state:.initial))
    }
    
    static var shared = ItemPickupDectection()
}
