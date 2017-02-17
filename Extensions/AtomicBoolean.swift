//
//  AtomicBoolean.swift
//  XFBConsumer
//
//  Created by hy110831 on 4/3/16.
//  Copyright © 2016 hy110831. All rights reserved.
//


typealias Byte = UInt8

struct AtomicBoolean {
    
    fileprivate var val: Byte = 0
    
    /// Sets the value, and returns the previous value.
    /// The test/set is an atomic operation.
    mutating func testAndSet(_ value: Bool) -> Bool {
        return false
//        if value {
//            return OSAtomicTestAndSet(0, &val)
//        } else {
//            return OSAtomicTestAndClear(0, &val)
//        }
    }
    
    /// Returns the current value of the boolean.
    /// The value may change before this method returns.
    func test() -> Bool {
        return val != 0
    }
    
}
