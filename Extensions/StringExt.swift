//
//  StringExt.swift
//  XFBConsumer
//
//  Created by hy110831 on 3/29/16.
//  Copyright © 2016 hy110831. All rights reserved.
//
import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    
    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
    var length:Int {
        return self.characters.count
    }
    
    func indexOf(_ target: String) -> Int
    {
        let range = self.range(of: target)
        if let range = range {
            return self.characters.distance(from: self.startIndex, to: range.lowerBound)
        } else {
            return -1
        }
    }
    
    func asciiValueOfString() -> [UInt32] {
        
        var retVal = [UInt32]()
        for val in self.unicodeScalars where val.isASCII {
            retVal.append(UInt32(val))
        }
        return retVal
    }
    
    func stringByAddingPercentEncodingForURLQueryValue() -> String? {
        let allowedCharacters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~")
        
        return self.addingPercentEncoding(withAllowedCharacters: allowedCharacters)
    }
    
    subscript(i: Int) -> String {
        guard i >= 0 && i < characters.count else { return "" }
        let i = index(startIndex, offsetBy: i)
        return self[i...i]
    }
    subscript(range: CountableRange<Int>) -> String {
        let lowerIndex = index(startIndex, offsetBy: max(0,range.lowerBound), limitedBy: endIndex) ?? endIndex
        return self[lowerIndex..<(index(lowerIndex, offsetBy: range.upperBound - range.lowerBound, limitedBy: endIndex) ?? endIndex)]
    }
    subscript(range: ClosedRange<Int>) -> String {
        let lowerIndex = index(startIndex, offsetBy: max(0,range.lowerBound), limitedBy: endIndex) ?? endIndex
        return self[lowerIndex..<(index(lowerIndex, offsetBy: range.upperBound - range.lowerBound + 1, limitedBy: endIndex) ?? endIndex)]
    }
}
