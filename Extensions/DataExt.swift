//
//  DataExt.swift
//  pg102
//
//  Created by hy110831 on 1/14/17.
//  Copyright © 2017 hy110831. All rights reserved.
//

import Foundation

extension Data {
    func hexEncodedString() -> String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
}
