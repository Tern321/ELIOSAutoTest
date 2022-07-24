//
//  IOSMessageManager.swift
//  SocketClient
//
//  Created by EVGENII Loshchenko on 16.07.2022.
//

import UIKit

class IOSAutotestMessageManager: ELPRequestClientMessageManager {
    
    override init() {
        super.init()
        var openPorts = true
        if openPorts {
            self.IP = "192.168.1.10"
            self.port = 5201
        } else {
            self.IP = "127.0.0.1"
            self.port = 5301
        }
        
        self.SharedApiKey = "iosAutotestSharedApi"
        self.HttpApiKey = "iosAutotestApi"
        self.clientId = "ios_forum_client_1"
    }
    
    override func respondToMessage(requestObject: ELPClientRequestObject) -> String {
        let page = ELPRequestClientMessageManager.page(requestObject)
        let responseMessage = ELPClientResponseMessage(requestObject.requestInfo?.RequestIndex ?? "", HttpApiKey)
        return responseMessage.updateResponse("test ios response 3")
    }
    
    func sendSharedMessage() {
        print("sendSharedMessage");

        var responseMessage = ELPClientResponseMessage("", HttpApiKey);
        responseMessage.MessageType = ELPRequestMessage.sharedApiData;
        responseMessage.Response = "shared message from c#";
        responseMessage.ApiKey = SharedApiKey;
        client.sendDataAsMessage(stringData: responseMessage.ToJson());
    }
    
    
    func modelIdentifier() -> String {
        if let simulatorModelIdentifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] { return simulatorModelIdentifier }
        var sysinfo = utsname()
        uname(&sysinfo) // ignore return value
        return String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
    }
    
    static func visibleViewControllerName() -> String {
        if let nk = UIApplication.shared.topMostViewController() as? UINavigationController {
            return String(describing: type(of: nk.visibleViewController!))
            
        } else {
            if let vk = UIApplication.shared.topMostViewController() as? UIViewController {
                return String(describing: type(of: vk))
            }
        }
        return "";
    }
        
    override func gotSharedMessage(message: ELPClientResponseMessage, data: Data) {
        print("test")
//        let value = UIInterfaceOrientation.landscapeLeft.rawValue
//        UIDevice.current.setValue(value, forKey: "orientation")
        
        if message.ClientMessageType == "GetTestData" {
            
            let data = ELTestableViewController.captureScreenshot()
            
            var testInfo = try! JSONDecoder().decode(TestScreenData.self, from: message.Response!.data(using: .utf8)!)
            testInfo.viewControllerName = IOSAutotestMessageManager.visibleViewControllerName()
            testInfo.rotation = UIDevice.current.orientation.rawValue
            testInfo.screenBase64 = data.base64EncodedString()
            testInfo.deviceModel = modelIdentifier()
            testInfo.viewControllerStateDataJson = "{}"
            testInfo.lang = Locale.current.languageCode ?? ""
            
            RootViewController.shared?.manager.sendSharedMessage(message: testInfo.ToJson(), ClientMessageType: "GetTestDataResponse")
            
            // send viewController info and image and device data
        } else if message.ClientMessageType == "RunTestCase" {
            // get Data, run test, send message
           
            
            var testInfo = try! JSONDecoder().decode(TestScreenData.self, from: message.Response!.data(using: .utf8)!)
            
            runTestCaseWithStateJson(testInfo: testInfo)
        }
        
        
            
        func pushTestedViewController(testedViewController: UIViewController) {
            var currentViewController = UIWindow.key?.rootViewController as? UINavigationController
//            var nk = currentViewController?.navigationController
////            currentViewController.po
//            if currentViewController?.presentingViewController != nil {
//                currentViewController?.dismiss(animated: false, completion: {
//                    currentViewController?.navigationController!.popToRootViewController(animated: true)
//                })
//            }
//            else {
//                currentViewController?.navigationController?.popToRootViewController(animated: true)
//            }
            currentViewController?.popToRootViewController(animated: true)
            currentViewController?.pushViewController(testedViewController, animated: false)
        }
        
        func runTestCaseWithStateJson(testInfo: TestScreenData) {
            var testedViewControllerClass = NSClassFromString("ELIOSAutoTest." + testInfo.viewControllerName!) as! ELTestableViewController.Type
            var testedViewController = testedViewControllerClass.loadViewControllerFromXib() as! ELTestableViewController

            UIDevice.current.setValue(testInfo.rotation, forKey: "orientation")
            
            pushTestedViewController(testedViewController: testedViewController)
            
//            testInfo.lang = Locale.current.languageCode ?? ""
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                let data = ELTestableViewController.captureScreenshot()
                testInfo.screenBase64 = data.base64EncodedString()
                RootViewController.shared?.manager.sendSharedMessage(message: testInfo.ToJson(), ClientMessageType: "RunTestCaseResponse")
            }
        }
    }
}
