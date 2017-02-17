//
//  DateExt.swift
//  XFBConsumer
//
//  Created by hy110831 on 4/12/16.
//  Copyright © 2016 hy110831. All rights reserved.
//

import Foundation

var rfc3999DateFormatter:DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSS'Z'"
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    return formatter
}
