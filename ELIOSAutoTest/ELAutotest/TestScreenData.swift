//
//  TestScreenData.swift
//  ELIOSAutoTest
//
//  Created by EVGENII Loshchenko on 24.07.2022.
//

import UIKit

class TestScreenData: Codable {
    var testName: String? = ""
    var testCaseId: String? = ""
    
    
    var rotation: Int = 1
    var screenBase64: String? = ""
    var deviceId: String? = ""
    var deviceModel: String? = ""
    var lang: String? = ""
    var testRunId: String? = ""
    
    var viewControllerName: String? = ""
    var viewControllerStateDataJson: String? = ""
    var applicationStateDataJson: String? = ""
    
    public func ToJson() -> String {
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(self)
        return String(data: jsonData ?? Data(), encoding: String.Encoding.utf8) ?? ""
    }
}
