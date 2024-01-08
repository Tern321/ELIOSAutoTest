//
//  IOSAutotestEvent.swift
//  ELIOSAutoTest
//
//  Created by jack on 02.09.2023.
//

import UIKit

enum IOSAutotestEventType: String {
    case click
    case screenshot
//    case
}
class AutotestEvent: NSObject, Codable {
    
    var autotestEventId: Int = 0
    var eventType: String = IOSAutotestEventType.click.rawValue
    var point: String?
    var windowType: String?
    var windowIndex: Int?
    var delay: Double?
    var rotation: Int = 1
//    var screenShot: TestScreenshotData?
    
    var hashStr: String?
    var screenBase64: String?
    
    func setPoint(_ point: CGPoint) {
        self.point = NSCoder.string(for: point)
    }
    
    func getCGPoint() -> CGPoint? {
        if point == nil {
            return nil
        }
        return NSCoder.cgPoint(for: point!)
    }
    
    func eventTypeEnum() -> IOSAutotestEventType {
        return IOSAutotestEventType.init(rawValue: eventType)!
    }
}
