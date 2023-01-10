//
//  Data+Extension.swift
//  Webim.Ru
//
//  Created by EVGENII Loshchenko on 28.03.2021.
//  Copyright © 2021 _webim_. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import UIKit

extension Data {
    
    var utf8String: String {
        return String(decoding: self, as: UTF8.self)
    }
    
    var prettyUtf8LogString: String {
        if let str = self.prettyPrintedJSONString {
            var logString = "\(str)"
            
            // "[ ]," in one line
            if let regex = try? NSRegularExpression(pattern: "(\\[\n\n[ ]{1,100}\\])", options: .caseInsensitive) {
                let modString = regex.stringByReplacingMatches(in: logString, options: [], range: NSRange(location: 0, length: logString.count), withTemplate: "[]")
                logString = modString
            }
            
            // "{ }," in one line
            if let regex = try? NSRegularExpression(pattern: "(\\{\n\n[ ]{1,100}\\})", options: .caseInsensitive) {
                let modString = regex.stringByReplacingMatches(in: logString, options: [], range: NSRange(location: 0, length: logString.count), withTemplate: "{ }")
                logString = modString
            }
            // "}, {" in one line
            if let regex = try? NSRegularExpression(pattern: "(\\},\n[ ]{1,100}\\{)", options: .caseInsensitive) {
                let modString = regex.stringByReplacingMatches(in: logString, options: [], range: NSRange(location: 0, length: logString.count), withTemplate: "}, {")
                logString = modString
            }
            
            return logString
        }
        return String(data: self, encoding: String.Encoding.utf8) ?? "nil or error"
    }
    
    var prettyPrintedJSONString: NSString? { /// NSString gives us a nice sanitized debugDescription
        var options: JSONSerialization.WritingOptions = [JSONSerialization.WritingOptions.prettyPrinted]
        if #available(iOS 13.0, *) {
            options = [.prettyPrinted, .withoutEscapingSlashes]
        }
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: options),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }

        return prettyPrintedString
    }
}
