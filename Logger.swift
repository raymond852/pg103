//
//  logger.swift
//  pg
//
//  Created by hy110831 on 8/24/16.
//  Copyright © 2016 hy110831. All rights reserved.
//

import Foundation
import SwiftyBeaver



class Logger: NSObject {
    
    static var dateFormatter:DateFormatter =  {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.S"
        return formatter
    }()
    
    static var log:SwiftyBeaver.Type = {
        let console = ConsoleDestination()
        let log = SwiftyBeaver.self
        log.addDestination(console)
        return log
    }()
    
    static func verbose(_ message: @autoclosure () -> Any) {
        log.verbose(message)
    }
    
    
    static func debug(_ message: @autoclosure () -> Any) {
        log.debug(message)
    }
    
    
    static func warning(_ message: @autoclosure () -> Any) {
        log.warning(message)
    }
    
    static func info(_ message: @autoclosure () -> Any) {
        log.info(message)
    }
    
    static func error(_ message: @autoclosure () -> Any) {
        log.error(message)
    }

    
}
