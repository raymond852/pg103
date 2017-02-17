//
//  pop+snapkit.swift
//  pg
//
//  Created by hy110831 on 8/22/16.
//  Copyright © 2016 hy110831. All rights reserved.
//

import Foundation
//
//  POP+SnapKit.swift
//  POP+SnapKit
//
//  Created by Gesen on 15/6/8.
//  Copyright (c) 2015年 Gesen. All rights reserved.
//
//  POP(1.0.9) + SnapKit(0.21.1)

import Foundation
import pop
import SnapKit

public extension Constraint {
    public var layoutConstraint: NSLayoutConstraint? {
        return layoutConstraints?.flatMap {
            guard let constraint = _valueForKey("snp_constraint", $0) as? Constraint , constraint === self else { return nil }
            return $0
            }.first
    }
    
    public var layoutConstraints: [NSLayoutConstraint]? {
        guard let installInfo = _valueForKey("installInfo", self) as? UIView else { return nil }
        return installInfo.constraints
    }
}

private func _valueForKey(_ key: String, _ fromObject: AnyObject) -> AnyObject? {
    let ivar = class_getInstanceVariable(type(of: fromObject), key)
    return object_getIvar(fromObject, ivar) as AnyObject?
}
