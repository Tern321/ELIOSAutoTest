//
//  ELProxyUtils.swift
//  SocketClient
//
//  Created by EVGENII Loshchenko on 12.07.2022.
//

import UIKit

public extension String {
    
    /// Assuming the current string is base64 encoded, this property returns a String
    /// initialized by converting the current string into Unicode characters, encoded to
    /// utf8. If the current string is not base64 encoded, nil is returned instead.
    var base64Decoded: String? {
        guard let base64 = Data(base64Encoded: self) else { return nil }
        let utf8 = String(data: base64, encoding: .utf8)
        return utf8
    }
    
    var base64DecodedBytes: Data? {
        return Data(base64Encoded: self)
    }
    
    /// Returns a base64 representation of the current string, or nil if the
    /// operation fails.
    var base64Encoded: String? {
        let utf8 = self.data(using: .utf8)
        let base64 = utf8?.base64EncodedString()
        return base64
    }
    
}
