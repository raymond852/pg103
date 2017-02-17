//
//  BLEPeripheral.swift
//  pg102
//
//  Created by hy110831 on 1/2/17.
//  Copyright © 2017 hy110831. All rights reserved.
//

import Foundation
import CoreBluetooth

protocol BLEPeripheralConnectable:class {
    func connect()
    func disconnect()
}

protocol BLEPeripheral: BLEPeripheralConnectable {
    var name:String {get}
    var services:[CBUUID:BLEPeripheralService] {get}
    
    var didConnectHandler:((Void)->(Void))? {get set}
    var didDisconnectHandler:((Void)->(Void))? {get set}
    var didFailConnectHandler:((Error?)->(Void))? {get set}
}

extension BLEPeripheral {
    
    func connect() {
        BLEHelper.shared.addPeripheral(self)
    }
    
    func disconnect() {
        BLEHelper.shared.removePeripheral(self)
    }
    
}

protocol BLEPeripheralService: class {
    var uuid:CBUUID {get}
    var characteristics:[CBUUID:BLEPeripheralCharacteristic] {get}
    
    var didReadyHandler:((Void)->(Void))? {get set}
    
    unowned var peripheral: BLEPeripheral {get set}
}

struct BLEPeripheralCharacteristicOptions: OptionSet {
    let rawValue: Int
    
    static let read = BLEPeripheralCharacteristicOptions(rawValue: 1 << 0)
    static let write = BLEPeripheralCharacteristicOptions(rawValue: 1 << 1)
    static let notify = BLEPeripheralCharacteristicOptions(rawValue: 1 << 2)
    
    static let readWrite:BLEPeripheralCharacteristicOptions = [.read, .write]
    static let all:BLEPeripheralCharacteristicOptions = [.read, .write, .notify]
}


protocol BLEPeripheralCharacteristicReadWrite:class {
    
    func writeValue(_ data:Data, type: CBCharacteristicWriteType, completionHandler:((Error?)->(Void))?)
    
    func readValue()
}

protocol BLEPeripheralCharacteristic:BLEPeripheralCharacteristicReadWrite {
    
    unowned var service:BLEPeripheralService {get}
    
    var uuid:CBUUID {get}
    var options:BLEPeripheralCharacteristicOptions {get}
    
    var valueUpdatedHandler:((Data?, Error?)-> Void)? {get set}
}


extension BLEPeripheralCharacteristic {
    
    func writeValue(_ data:Data, type: CBCharacteristicWriteType, completionHandler:((Error?)->(Void))?) {
        BLEHelper.shared.writeValue(data, for: self.service.peripheral, for: self, type: CBCharacteristicWriteType.withResponse, completionHandler: completionHandler)
    }
    
    func readValue() {
       BLEHelper.shared.readValue(for: self.service.peripheral, for: self)
    }
    
}
