//
//  IOSMessageManager.swift
//  SocketClient
//
//  Created by EVGENII Loshchenko on 16.07.2022.
//

import UIKit

class IOSAutotestMessageManager: ELPRequestClientMessageManager {
    
    static var manager: IOSAutotestMessageManager = {
            return  IOSAutotestMessageManager()
        }()
    
    var testsToRun: [TestScreenData] = []
    var timer: Timer?
    
    @objc func runTestCycle() {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//            self.runTestCycle()
//        }
        DispatchQueue.main.async {
            if !self.testsToRun.isEmpty {
                print("run test case \(self.testsToRun)")
                self.runTestCaseWithStateJson(testInfo: self.testsToRun.removeFirst())
            }
        }
        
    }
    
    override init() {
        
        super.init()
        let openPorts = false
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
        runTestCycle()
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(runTestCycle), userInfo: nil, repeats: true)
        start()
    }
    
    override func respondToMessage(requestObject: ELPClientRequestObject) -> String {
//        let page = ELPRequestClientMessageManager.page(requestObject)
        let responseMessage = ELPClientResponseMessage(requestObject.requestInfo?.RequestIndex ?? "", HttpApiKey)
        return responseMessage.updateResponse("test ios response 3")
    }
    
    func sendSharedMessage() {
        print("sendSharedMessage")

        let responseMessage = ELPClientResponseMessage("", HttpApiKey)
        responseMessage.MessageType = ELPRequestMessage.sharedApiData
        responseMessage.Response = "shared message from c#"
        responseMessage.ApiKey = SharedApiKey
        client.sendDataAsMessage(stringData: responseMessage.ToJson())
    }
    
    func modelIdentifier() -> String {
        if let simulatorModelIdentifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] { return simulatorModelIdentifier }
        var sysinfo = utsname()
        uname(&sysinfo) // ignore return value
        return String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
    }
    
    static func vissibleViewController() -> UIViewController? {
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
    
    override func gotSharedMessage(message: ELPClientResponseMessage, data: Data) {
        print("gotSharedMessage")
//        let value = UIInterfaceOrientation.landscapeLeft.rawValue
//        UIDevice.current.setValue(value, forKey: "orientation")
        
        if message.ClientMessageType == "GetTestData" {
            
            let data = ELTestableViewController.captureScreenshot()
            
            let testInfo = message.testScreenData()
            testInfo.viewControllerName = IOSAutotestMessageManager.visibleViewControllerName()
            testInfo.rotation = UIDevice.current.orientation.rawValue
            testInfo.screenBase64 = data.base64EncodedString()
            testInfo.deviceModel = modelIdentifier()
            testInfo.viewControllerStateDataJson = "{}"
            testInfo.lang = Locale.current.languageCode ?? ""
            testInfo.hideBackButton = IOSAutotestMessageManager.vissibleViewController()?.navigationController?.navigationBar.backItem == nil
            
            print("GetTestData")
            print(testInfo.ToJson())
            
            IOSAutotestMessageManager.manager.sendSharedMessage(message: testInfo.ToJson(), ClientMessageType: "GetTestDataResponse", targetClientId: "c#_AutotestBackend_client1")
            
            // send viewController info and image and device data
        } else if message.ClientMessageType == "RunTestCase" {
            // get Data, run test, send message
            
            let testInfo = message.testScreenData()
            testsToRun.append(testInfo)
        }
        
    }
    func pushTestedViewController(testedViewController: UIViewController, hideBackButton: Bool) {
        let currentViewController = UIWindow.key?.rootViewController as? UINavigationController
        currentViewController?.navigationController?.navigationItem.hidesBackButton = hideBackButton
        currentViewController?.popToRootViewController(animated: false)
        currentViewController?.pushViewController(testedViewController, animated: false)
        if hideBackButton {
            testedViewController.navigationItem.setHidesBackButton(true, animated: false)
//            testedViewController.navigationController?.navigationItem.hidesBackButton = true
        }
        
    }
    
    func runTestCaseWithStateJson(testInfo: TestScreenData) {
        let testedViewControllerClass = NSClassFromString("ELIOSAutoTest." + testInfo.viewControllerName!) as! ELTestableViewController.Type
        let testedViewController = testedViewControllerClass.loadViewControllerFromXib()

        UIDevice.current.setValue(testInfo.rotation, forKey: "orientation")
        
        pushTestedViewController(testedViewController: testedViewController, hideBackButton: testInfo.hideBackButton)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let data = ELTestableViewController.captureScreenshot()
            testInfo.screenBase64 = data.base64EncodedString()
            
            testInfo.rotation = UIDevice.current.orientation.rawValue
            testInfo.deviceModel = self.modelIdentifier()
            testInfo.viewControllerStateDataJson = "{}"
            testInfo.lang = Locale.current.languageCode ?? ""
            
            IOSAutotestMessageManager.manager.sendSharedMessage(message: testInfo.ToJson(), ClientMessageType: "RunTestCaseResponse", targetClientId: "c#_AutotestBackend_client1")
        }
    }
}
