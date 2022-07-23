//
//  RootViewController.swift
//  ELIOSAutoTest
//
//  Created by EVGENII Loshchenko on 14.07.2022.
//

import UIKit
import MediaPlayer
import AudioToolbox

class TestScreenData: Codable {
    var testName: String? = ""
    var testCaseId: String? = ""
    
    var viewControllerName: String? = ""
    var rotation: String? = ""
    var screenBase64: String? = ""
    var viewControllerModelJson: String? = ""
    var deviceId: String? = ""
    var deviceModel: String? = ""
    var lang: String? = ""
    var testRunId: String? = ""
    
    public func ToJson() -> String {
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(self)
        return String(data: jsonData ?? Data(), encoding: String.Encoding.utf8) ?? ""
    }
}
class RootViewController: UIViewController {

    static var shared: RootViewController?
    var testObjcObj = ObjcTestClass()
    var manager = IOSAutotestMessageManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.start()
        RootViewController.shared = self
        
//        test()
//
//        testObjcObj.start(nil)
    }
    @IBAction func test() {
        var data = captureScreenshot()
        var testInfo = TestScreenData()
        testInfo.rotation = "v"
        
        
        
        testInfo.screenBase64 = data.base64EncodedString()
//        testInfo.testName = "test1"
        
        
        manager.sendSharedMessage(message: testInfo.ToJson())
        
    }
    func showData() {
        var a = UIApplication.shared.windows.count
        print(a)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //        AppDelegate.shared.deviceOrientation = .landscapeLeft
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    func captureScreenshot() -> Data {
        let layer = UIApplication.shared.keyWindow!.layer
        let scale = UIScreen.main.scale
        // Creates UIImage of same size as view
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        var data = screenshot?.jpegData(compressionQuality: 0.5)
        return data!
    }
    
}
