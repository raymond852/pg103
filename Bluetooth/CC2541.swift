//
//  CC2541.swift
//  pg102
//
//  Created by hy110831 on 1/2/17.
//  Copyright © 2017 hy110831. All rights reserved.
//

import Foundation
import CoreBluetooth

class CC2541:BLEPeripheral {
    
    var name: String = "PGBLEPeripheral"
    
    lazy var services:[CBUUID:BLEPeripheralService] = {
        let service = CC2541Service(peripheral: self)
        return [service.uuid: service]
    }()
    
    lazy var coreService:CC2541Service! = {
        for service in self.services.values {
            if service is CC2541Service {
                return service as! CC2541Service
            }
        }
        return nil
    }()
    
    
    var didConnectHandler: ((Void) -> (Void))?
    
    var didDisconnectHandler: ((Void) -> (Void))?
    
    var didFailConnectHandler: ((Error?) -> (Void))?
    
    private init() {
        self.didConnectHandler = {
            Logger.info("CC2541 connected")
        }
        
        self.didDisconnectHandler = {
            Logger.info("CC2541 disconnected")
            DispatchQueue.main.async {
                StyleHelper.showErrorAlertWithTitle("已断开连接")
            }
            return
        }
        
        self.didFailConnectHandler = { (error) in
            Logger.info("CC2541 failed to connect with error \(error)")
            return
        }
    }
    
    func lightOffLed() {
        self.coreService.ledCharateristic.lightOffLeds()
    }
    
    func lightOnLed(withLevel level:Int) {
        var command:String!
        switch level {
        case 2:
            command = "190000"
            break
        case 3:
            command = "100090"
            break
        default:
            command = "100900"
        }
        let data = command.data(using: String.Encoding.ascii)!
        self.coreService.ledCharateristic.writeValue(data, type: CBCharacteristicWriteType.withoutResponse) { (error) -> (Void) in
            if let err = error {
                Logger.error(err)
            }
        }
    }
    
    
    func readLevel(level:Int) {
        switch level {
        case 1:
            self.coreService.level1Charateristic.readValue()
        case 2:
            self.coreService.level2Charateristic.readValue()
        case 3:
            self.coreService.level3Charateristic.readValue()
        default:
            self.coreService.level4Charateristic.readValue()
        }
    }
    
    static var shared = CC2541()
    
}


class CC2541Service:BLEPeripheralService {
    
    var uuid: CBUUID = CBUUID(string: "3F29121C-FA01-000A-0001-000000000000")
    
    lazy var ledCharateristic:CC2541LedCharacteristic! = {
        for charateristic in self.characteristics.values {
            if charateristic is CC2541LedCharacteristic {
                return charateristic as! CC2541LedCharacteristic
            }
        }
        return nil
    }()

    lazy var level1Charateristic:CC2541WeightLevel1Characteristic! = {
        for charateristic in self.characteristics.values {
            if charateristic is CC2541WeightLevel1Characteristic {
                return charateristic as! CC2541WeightLevel1Characteristic
            }
        }
        return nil
    }()
    
    lazy var level2Charateristic:CC2541WeightLevel2Characteristic! = {
        for charateristic in self.characteristics.values {
            if charateristic is CC2541WeightLevel2Characteristic {
                return charateristic as! CC2541WeightLevel2Characteristic
            }
        }
        return nil
    }()

    lazy var level3Charateristic:CC2541WeightLevel3Characteristic! = {
        for charateristic in self.characteristics.values {
            if charateristic is CC2541WeightLevel3Characteristic {
                return charateristic as! CC2541WeightLevel3Characteristic
            }
        }
        return nil
    }()
    
    lazy var level4Charateristic:CC2541WeightLevel4Characteristic! = {
        for charateristic in self.characteristics.values {
            if charateristic is CC2541WeightLevel4Characteristic {
                return charateristic as! CC2541WeightLevel4Characteristic
            }
        }
        return nil
    }()
    
    lazy var characteristics: [CBUUID:BLEPeripheralCharacteristic] = {
        let ledCharacteristic = CC2541LedCharacteristic(service: self)
        let level1Characteristic = CC2541WeightLevel1Characteristic(service: self)
        let level2Characteristic = CC2541WeightLevel2Characteristic(service: self)
        let level3Characteristic = CC2541WeightLevel3Characteristic(service: self)
        let level4Characteristic = CC2541WeightLevel4Characteristic(service: self)
        return [
            ledCharacteristic.uuid : ledCharacteristic,
            level1Characteristic.uuid : level1Characteristic,
            level2Characteristic.uuid : level2Characteristic,
            level3Characteristic.uuid : level3Characteristic,
            level4Characteristic.uuid : level4Characteristic
        ]
    }()
    
    var didReadyHandler: ((Void) -> (Void))?
    
    unowned var peripheral: BLEPeripheral
    
    init(peripheral: BLEPeripheral) {
        self.peripheral = peripheral
        self.didReadyHandler = { [weak self] in
            self?.ledCharateristic.lightOffLeds()
            DispatchQueue.global().async {
                CC2541.shared.readLevel(level: 1)
            }
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.2, execute: { 
                CC2541.shared.readLevel(level: 2)
            })
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.4, execute: {
                CC2541.shared.readLevel(level: 3)
            })
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.6, execute: {
                CC2541.shared.readLevel(level: 4)
            })
            ItemPickupDectection.shared.startRunning()
        }
    }
}


class CC2541LedCharacteristic:BLEPeripheralCharacteristic {
    
    var uuid: CBUUID = CBUUID(string: "3F29121C-FB01-000A-0001-000000000000")
    var options: BLEPeripheralCharacteristicOptions = .readWrite
    
    unowned var service: BLEPeripheralService
    
    var valueUpdatedHandler: ((Data?, Error?) -> Void)?
    
    init(service:BLEPeripheralService) {
        self.service = service
        self.valueUpdatedHandler = { (val, error) in
            if let value = val {
                Logger.info("LED Output \(value)")
            }
        }
    }
    
    func lightOffLeds() {
        let command = "100000"
        let data = command.data(using: String.Encoding.ascii)!
        self.writeValue(data, type: CBCharacteristicWriteType.withoutResponse) { (error) -> (Void) in
            if let err = error {
                Logger.error(err)
            }
        }
    }
    
    
}

class CC2541WeightLevel1Characteristic:BLEPeripheralCharacteristic {
    
    var uuid:CBUUID = CBUUID(string: "3F29121C-F001-000A-0001-000000000000")
    var options:BLEPeripheralCharacteristicOptions = [.read, .notify]
    
    unowned var service:BLEPeripheralService
    
    var valueUpdatedHandler: ((Data?, Error?) -> Void)?
    
    init(service:BLEPeripheralService) {
        self.service = service
        self.valueUpdatedHandler = { (val, error) in
            if let value = val {
                ItemPickupDectection.shared.feedData(value, level: 1)
                                let valStr = value.hexEncodedString()
                                var print:String = "level 1 "
                                var total:Int = 0
                                for i in  0 ..< 8 {
                                    let start = 4 * i
                                    let end = 4 * i + 1
                                    var read = UInt16(valStr[start...end], radix: 16)!
                                    if read == 255 {
                                        read = 0
                                    }
                                    print += "\(read)-"
                                    total += Int(read)
                                }
                                Logger.info(print + " total:\(total)")
            }
        }
    }
    

}

class CC2541WeightLevel2Characteristic:BLEPeripheralCharacteristic {
    
    var uuid:CBUUID = CBUUID(string: "3F29121C-F002-000A-0001-000000000000")
    var options:BLEPeripheralCharacteristicOptions = [.read, .notify]
    
    unowned var service:BLEPeripheralService
    
    var valueUpdatedHandler: ((Data?, Error?) -> Void)?
    
    init(service:BLEPeripheralService) {
        self.service = service
        self.valueUpdatedHandler = { (val, error) in
            if let value = val {
               ItemPickupDectection.shared.feedData(value, level: 4)
                let valStr = value.hexEncodedString()
                var print:String = "level 4 "
                var total:Int = 0
                for i in  0 ..< 8 {
                    let start = 4 * i
                    let end = 4 * i + 1
                    var read = UInt16(valStr[start...end], radix: 16)!
                    if read == 255 {
                        read = 0
                    }
                    print += "\(read)-"
                    total += Int(read)
                }
                Logger.info(print + " total:\(total)")
            }
        }
    }
    
}


class CC2541WeightLevel3Characteristic:BLEPeripheralCharacteristic {
    
    var uuid:CBUUID = CBUUID(string: "3F29121C-F003-000A-0001-000000000000")
    var options:BLEPeripheralCharacteristicOptions = [.read, .notify]
    
    unowned var service:BLEPeripheralService
    
    var valueUpdatedHandler: ((Data?, Error?) -> Void)?
    
    var timer:Timer!
    
    init(service:BLEPeripheralService) {
        self.service = service
        self.valueUpdatedHandler = { (val, error) in
            if let value = val {
                ItemPickupDectection.shared.feedData(value, level: 3)
                let valStr = value.hexEncodedString()
                var print:String = "level 3 "
                for i in  0 ..< 8 {
                    let start = 4 * i
                    let end = 4 * i + 1
                    let read = UInt16(valStr[start...end], radix: 16)!
                    print += "\(read)-"
                }
               Logger.info(print)
            }
        }
    }
    
}

class CC2541WeightLevel4Characteristic:BLEPeripheralCharacteristic {
    
    var uuid:CBUUID = CBUUID(string: "3F29121C-F004-000A-0001-000000000000")
    var options:BLEPeripheralCharacteristicOptions = [.read, .notify]
    
    unowned var service:BLEPeripheralService
    
    var valueUpdatedHandler: ((Data?, Error?) -> Void)?
    
    init(service:BLEPeripheralService) {
        self.service = service
        self.valueUpdatedHandler = { (val, error) in
            if let value = val {
                ItemPickupDectection.shared.feedData(value, level: 2)
                let valStr = value.hexEncodedString()
                var print:String = "level 2 "
                var total:Int = 0
                for i in  0 ..< 8 {
                    let start = 4 * i
                    let end = 4 * i + 1
                    var read = UInt16(valStr[start...end], radix: 16)!
                    if read == 255 {
                        read = 0
                    }
                    print += "\(read)-"
                    total += Int(read)
                }
                Logger.info(print + " total:\(total)")
            }
        }
    }
    
}

