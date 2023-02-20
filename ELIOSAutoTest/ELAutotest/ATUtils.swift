//
//  ATUtils.swift
//  ELIOSAutoTest
//
//  Created by EVGENII Loshchenko on 12.01.2023.
//

import UIKit

class ATUtils: NSObject {
    static func visibleViewController() -> UIViewController? {
        if let nk = UIApplication.shared.topMostViewController() as? UINavigationController {
            return nk.visibleViewController
            
        } else {
            if let vk = UIApplication.shared.topMostViewController() {
                return vk
            }
        }
        return nil
    }
    
    static func visibleViewControllerName() -> String {
        if let nk = UIApplication.shared.topMostViewController() as? UINavigationController {
            return String(describing: type(of: nk.visibleViewController!))
            
        } else {
            if let vk = UIApplication.shared.topMostViewController() {
                return String(describing: type(of: vk))
            }
        }
        return ""
    }
    
    static func modelIdentifier() -> String {
        if let simulatorModelIdentifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] { return simulatorModelIdentifier }
        var sysinfo = utsname()
        uname(&sysinfo) // ignore return value
        return String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
    }
}

extension Decodable {
    static func loadFromJson<T: Decodable>(json: String?) -> T? {
        if let dataJson = json?.data(using: .utf8) {
            return try? JSONDecoder().decode(T.self, from: dataJson)
        }
        return nil
    }
}

extension Encodable {
    func toJson() -> String? {
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(self)
        return String(data: jsonData ?? Data(), encoding: String.Encoding.utf8)
    }
}
