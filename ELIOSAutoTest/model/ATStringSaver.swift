//
//  ATStringSaver.swift
//  ELIOSAutoTest
//
//  Created by EVGENII Loshchenko on 13.01.2023.
//

import UIKit

class ATStringSaver: Codable {
    static var shared = ATStringSaver()
    
    var str = "someString"
}
extension ATStringSaver: ELAutotestModelObject {
    
    static func getStateModelJson() -> String? {
        return shared.toJson()
    }
    static func loadStateStateObject(json: String?) {
        if let json = json {
            self.shared = ATStringSaver.loadFromJson(json: json) ?? ATStringSaver()
        }
        else {
            self.shared = ATStringSaver()
        }
    }
}
