//
//  TestScreenData.swift
//  ELIOSAutoTest
//
//  Created by EVGENII Loshchenko on 24.07.2022.
//

import UIKit



class TestCaseData: Codable {
    var standardTestCaseDataId: Int?
    
    var testId: Int?
    var testCaseName: String? = ""
    var testCaseId: Int?
    var testRunId: Int?
    
    // create/run response
    //envirement
    var deviceModel: String? = ""
    var lang: String? = ""
    var deviceId: String? = ""
    var OS: String? = ""
    
    // state
    var hideBackButton: Bool = false
    var viewControllerName: String? = ""
    var viewControllerStateDataJson: String? = ""
    var applicationStateDataJson: String? = ""
    var rotation: Int = 0
    
    // result
    var autotestEvents: [AutotestEvent]? = [AutotestEvent]()
    var autotestEventIds: String? = ""
    
    public func toJson() -> String {
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(self)
        return String(data: jsonData ?? Data(), encoding: String.Encoding.utf8) ?? ""
    }
}

// create TestActionRecord
//class TestCaseData: Codable {
//    // create
//    var testId: String? = ""
//    var testCaseName: String? = ""
//    var testCaseId: String? = ""
//    var deviceId: String? = "" // do i need this?
//
//    // create response
////    var setupData: TestcaseSetupData?
//    // create/run
//    var testRunId: String? = ""
//    var autotestEvents: [IOSAutotestEvent]? = [IOSAutotestEvent]()
//    // create/run response
////    var screenshots: [Int: TestScreenshotData]? //
//
//
//    // TestcaseSetupData
//    var hideBackButton: Bool = false
//
//    var deviceModel: String? = ""
//    var lang: String? = ""
//
//    var viewControllerName: String? = ""
//    var viewControllerStateDataJson: String? = ""
//    var applicationStateDataJson: String? = ""
//    var rotation: Int = 1
//
//    public func toJson() -> String {
//        let jsonEncoder = JSONEncoder()
//        let jsonData = try? jsonEncoder.encode(self)
//        return String(data: jsonData ?? Data(), encoding: String.Encoding.utf8) ?? ""
//    }
//}

class TestRunScreenshotData: Codable {
    var testRunId: String? = ""
    var testCaseId: String? = ""
    
    var testScreenshotDataId: Int?
    var screenBase64: String? = ""
    var rotation: Int = 1
    var lang: Int = 1
    
    var model: Int = 1
}

class TestScreenshotData: Codable {
    var testScreenshotDataId: Int?
    var screenBase64: String? = ""
    var rotation: Int = 1
}

//class TestcaseSetupData: Codable {
//
//
//    public func toJson() -> String {
//        let jsonEncoder = JSONEncoder()
//        let jsonData = try? jsonEncoder.encode(self)
//        return String(data: jsonData ?? Data(), encoding: String.Encoding.utf8) ?? ""
//    }
//}
