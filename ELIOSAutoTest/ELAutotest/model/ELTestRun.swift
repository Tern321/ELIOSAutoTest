//
//  ELTestRun.swift
//  ELIOSAutoTest
//
//  Created by jack on 06.12.2023.
//

import UIKit

class TestRunEventResult: Codable {
    var testRunEventResultId: Int?
    
    var testId: Int?
    var testRunId: Int?
    var standardTestCaseDataId: Int?
    var autotestEventId: Int = 0
    
    //envirement
    var deviceModel: String? = ""
    var lang: String? = ""
    var deviceId: String? = ""
    var OS: String? = ""
    
    var hashStr: String?
    var screenBase64: String?
    var rotation: Int = 0
}

class ELTestRun: Codable {
    
    var testRunId: Int?
    var testRunName: String? = ""
    var testId: Int?
    var date: String? = ""
    var deviceId: String? = ""
    var OS: String? = ""
    var forceRotation: String? = ""
    var forceLang: String? = ""
    var testCases: [StandardTestCaseData]? = [StandardTestCaseData]()
}

class StandardTestCaseData: Codable {
    var standardTestCaseDataId: Int
    var testCaseName: String?
    var autotestStandardEventIds: String? // change to array
    // TestSetupData
    var hideBackButton: Bool
    var viewControllerName: String?
    var viewControllerStateDataJson: String?
    var applicationStateDataJson: String?
    var rotation: Int
    var autotestEvents: [AutotestEvent] = []
}
//class StandardTestCaseData: Codable {
//    var standardTestCaseDataId: Int = 0
//    var testCaseName: String?
//    var autotestStandardEventIds: [String]? // change to array
//    // TestSetupData
//    var hideBackButton: Bool = false
//    var viewControllerName: String?
//    var viewControllerStateDataJson: String?
//    var applicationStateDataJson: String?
//    var rotation: Int = 0
//    
//    var autotestEvents: [IOSAutotestEvent]? = [IOSAutotestEvent]()
//}
