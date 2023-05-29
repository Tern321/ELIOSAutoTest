//
//  ELAutotestModelManager.swift
//  ELIOSAutoTest
//
//  Created by EVGENII Loshchenko on 07.01.2023.
//

import UIKit

@objc protocol ELAutotestModelObject {
    static func getStateModelJson() -> String? // should be codable
    static func loadStateStateObject(json: String?)
}

class ELAutotestModelManager: NSObject {
    var modelObjects: [String: String] = [String: String]() // className:json
}
