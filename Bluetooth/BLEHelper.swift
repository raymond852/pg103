//
//  BLEHelper.swift
//  pg102
//
//  Created by hy110831 on 1/1/17.
//  Copyright © 2017 hy110831. All rights reserved.
//

import Foundation
import CoreBluetooth

class BLEHelper: NSObject {
    
    lazy var centralManager: CBCentralManager = {
        let centralManager = CBCentralManager(delegate: self, queue: DispatchQueue(label: "BLUETOOTH"))
        return centralManager
    }()
    
    func scan() {
        if #available(iOS 9.0, *) {
            if !centralManager.isScanning {
                centralManager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
            }
        } else {
            // Fallback on earlier versions
            centralManager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
        }
    }
    
    func stopScan() {
        centralManager.stopScan()
    }
    
    // MARK: Singleton
    fileprivate override init() {
        super.init()
    }
    
    static var shared = BLEHelper()
    
    lazy var peripherals:[String:BLEPeripheral] = [:]
    lazy var internalPeripherals:[String:CBPeripheral] = [:]
    lazy var retainedPeripherals:Set<CBPeripheral> = Set()
    
    lazy var writeHandler:[String: ((Error?) -> Void)] = [:]
    
    func addPeripheral(_ peripheral:BLEPeripheral) {
        if self.peripherals[peripheral.name] == nil {
            self.peripherals[peripheral.name] = peripheral
        }
        for cbPeripheral in retainedPeripherals {
            if let name = cbPeripheral.name, name == peripheral.name {
                internalPeripherals[name] = cbPeripheral
                if cbPeripheral.state != .connected || cbPeripheral.state != .connecting {
                    self.centralManager.connect(cbPeripheral, options: nil)
                }
                break
            }
        }
    }
    
    func removePeripheral(_ peripheral:BLEPeripheral) {
        self.peripherals[peripheral.name] = nil
        if let internalPeripheral = internalPeripherals[peripheral.name] {
            centralManager.cancelPeripheralConnection(internalPeripheral)
        }
    }
    
    func writeValue(_ data:Data, for peripheral:BLEPeripheral, for characteristic:BLEPeripheralCharacteristic, type: CBCharacteristicWriteType, completionHandler: ((Error?) -> (Void))? = nil) {
        guard let cbPeripheral = internalPeripherals[peripheral.name], cbPeripheral.state == .connected, let services = cbPeripheral.services else {
            Logger.warning("\(peripheral.name) write before connection")
            return
        }
        
        var targetService:CBService? = nil
        for cbService in services {
            if cbService.uuid == characteristic.service.uuid {
                targetService = cbService
            }
        }
        
        if let foundService = targetService {
            if let characteristics = foundService.characteristics {
                for cbCharacteristic in characteristics {
                    if characteristic.uuid == cbCharacteristic.uuid {
                        cbPeripheral.writeValue(data, for: cbCharacteristic, type: type)
                        if let handler = completionHandler {
                            self.writeHandler[peripheral.name + foundService.uuid.uuidString + characteristic.uuid.uuidString] = handler
                        }
                        break
                    }
                }
            }
        } else {
            Logger.warning("cannot find coressponding service, abort write")
        }
    }
    
    func readValue(for peripheral:BLEPeripheral, for characteristic:BLEPeripheralCharacteristic) {
        guard let cbPeripheral = internalPeripherals[peripheral.name], cbPeripheral.state == .connected, let services = cbPeripheral.services else {
//            Logger.warning("\(peripheral.name) write before connection")
            return
        }
        
        var targetService:CBService? = nil
        for cbService in services {
            if cbService.uuid == characteristic.service.uuid {
                targetService = cbService
            }
        }
        
        if let foundService = targetService {
            if let characteristics = foundService.characteristics {
                for cbCharacteristic in characteristics {
                    if characteristic.uuid == cbCharacteristic.uuid {
                        cbPeripheral.readValue(for: cbCharacteristic)
                        break
                    }
                }
            }
        } else {
            Logger.warning("cannot find coressponding service, abort write")
        }
    }
}

extension BLEHelper: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            Logger.info("BLE powered on")
            scan()
        case .unsupported:
            Logger.warning("BLE unsupported")
        case .poweredOff:
            Logger.error("BLE power off")
        case .unknown:
            Logger.error("BLE unknown")
        case .unauthorized:
            Logger.error("BLE Unauthorized")
        case .resetting:
            Logger.error("BLE resetting")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        guard let name = peripheral.name, let blePeripheral = self.peripherals[name] else {
            return
        }
        
        peripheral.discoverServices(nil)
        peripheral.delegate = self
        if let connectHandler = blePeripheral.didConnectHandler {
            connectHandler()
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        guard let name = peripheral.name, let blePeripheral = self.peripherals[name] else {
            return
        }
        
        if let disconnectHandler = blePeripheral.didDisconnectHandler {
            disconnectHandler()
        }
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        guard let name = peripheral.name, let blePeripheral = self.peripherals[name] else {
            return
        }

        if let didFailConnectHandler = blePeripheral.didFailConnectHandler {
            didFailConnectHandler(error)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        retainedPeripherals.insert(peripheral)
        if let name = peripheral.name, self.peripherals.keys.contains(name) {
            self.internalPeripherals[name] = peripheral
            if peripheral.state != .connected || peripheral.state != .connecting {
                self.centralManager.connect(peripheral, options: nil)
            }
        }
    }
    
}

extension BLEHelper: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let name = peripheral.name, let blePeripheral = self.peripherals[name], let services = peripheral.services else {
            return
        }
        
        for service in services {
            if blePeripheral.services[service.uuid] != nil {
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        if let name = peripheral.name {
            if let handler = self.writeHandler[name + characteristic.service.uuid.uuidString + characteristic.uuid.uuidString] {
                handler(error)
                self.writeHandler[name + characteristic.service.uuid.uuidString + characteristic.uuid.uuidString] = nil
            }
        }
    }
    
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard let name = peripheral.name, let blePeripheral = self.peripherals[name] else {
            return
        }
        
        if let bleSerivce = blePeripheral.services[characteristic.service.uuid] {
            if let bleCharacteristic = bleSerivce.characteristics[characteristic.uuid] {
                bleCharacteristic.valueUpdatedHandler?(characteristic.value, error)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let name = peripheral.name, let blePeripheral = self.peripherals[name], let characteristics = service.characteristics else {
            return
        }
        
        if let bleService = blePeripheral.services[service.uuid] {
            for characteristic in characteristics {
                if let bleCharacteristic = bleService.characteristics[characteristic.uuid], bleCharacteristic.options.contains(.notify)  {
                    peripheral.setNotifyValue(true, for: characteristic)
                }
            }
            bleService.didReadyHandler?()
        }
    }
    
}
