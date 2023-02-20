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
