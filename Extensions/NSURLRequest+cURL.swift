//
//  NSURLRequest+cURL.swift
//  guitar
//
//  Created by hy110831 on 12/26/16.
//  Copyright © 2016 hy110831. All rights reserved.
//

import Foundation

extension NSURLRequest {
    
    /**
     *  Returns a cURL command for a request.
     *
     *  @return A String object that contains cURL command or nil if an URL is
     *  not properly initalized.
     */
    var cURL: String {
        
        if let length = self.url?.absoluteString.utf16.count {
            if length == 0 {
                return ""
            }
        } else {
            return ""
        }
        
        var curlCommand = "curl \n"
        
        // append URL
        curlCommand = curlCommand.appendingFormat(" '%@' \n", self.url!.absoluteString)
        
        // append method if different from GET
        if "GET" != self.httpMethod {
            curlCommand = curlCommand.appendingFormat(" -X %@ \n", self.httpMethod!)
        }
        
        // append headers
        let allHeadersFields = self.allHTTPHeaderFields!
        let allHeadersKeys = Array(allHeadersFields.keys)// as [String]
        let sortedHeadersKeys  = allHeadersKeys.sorted{ $0 < $1 }
        for key in sortedHeadersKeys {
            curlCommand = curlCommand.appendingFormat(" -H '%@: %@' \n", key, self.value(forHTTPHeaderField: key)!)
        }
        
        // append HTTP body
        let httpBody = self.httpBody
        if let count = httpBody?.count, count > 0  {
            let httpBody = NSString(data: self.httpBody!,
                                    encoding: String.Encoding.utf8.rawValue)
            let escapedHttpBody =
                NSURLRequest.escapeAllSingleQuotes(value: httpBody! as String)
            curlCommand = curlCommand.appendingFormat(" --data '%@' \n", escapedHttpBody)
        }
        
        return curlCommand
    }
    
    /**
     *  Escapes all single quotes for shell from a given string.
     *
     *  @param value The value to escape.
     *
     *  @return An escaped value.
     */
    class func escapeAllSingleQuotes(value: String) -> String {
        return
            value.replacingOccurrences(of:"'", with: "'\\''")
    }
}
