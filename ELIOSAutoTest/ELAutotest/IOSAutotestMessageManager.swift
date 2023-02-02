//
//  IOSMessageManager.swift
//  SocketClient
//
//  Created by EVGENII Loshchenko on 16.07.2022.
//

import UIKit

class IOSAutotestMessageManager: ELPRequestClientMessageManager {
    
    static let manager: IOSAutotestMessageManager = {
            return  IOSAutotestMessageManager()
        }()
    
    var testsToRun: [TestScreenData] = []
    var timer: Timer?
    
    @objc func runTestCycle() {
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
    
    func showTestErrorAlert(className: String) {
        let alert = UIAlertController(title: "Testing is not supported", message: "getVCModel not implemented for \(className)", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        ATUtils.vissibleViewController()?.present(alert, animated: true, completion: nil)
    }
    
    func getGlobalAppStateJson() -> String {
        var globalStateMap = [String: String]()
        
        let globalClasses = RuntimeExplorer.classes(conformToProtocol: ELAutotestModelObject.self)
        for obj in globalClasses {
            globalStateMap["\(obj)"] = obj.self.getStateModelJson()
        }
        return globalStateMap.toJson() ?? ""
    }
    
    func loadGlobalAppStateJson(json: String) {
        if let dataJson = json.data(using: .utf8) {
            let globalStateMap: [String: String] = try! JSONDecoder().decode([String: String].self, from: dataJson)

            let globalClasses = RuntimeExplorer.classes(conformToProtocol: ELAutotestModelObject.self)
            for obj in globalClasses {
                obj.loadStateStateObject(json: globalStateMap["\(obj)"])
            }
        }
    }
    override func gotSharedMessage(message: ELPClientResponseMessage, data: Data) {
        print("IOSAutotestMessageManager gotSharedMessage")
        
        if message.ClientMessageType == "GetTestData" {
            
            let data = ELTestableViewController.captureScreenshot()! // let it fall
            let VCModelJson = (ATUtils.vissibleViewController() as? ELTestableViewControllerModelProtocol)?.getModelJson()
            
            if VCModelJson == nil {
//                showTestErrorAlert(className: String(describing: type(of: ATUtils.vissibleViewController())))
                return
            }
            let testInfo = message.testScreenData()
            testInfo.viewControllerName = ATUtils.visibleViewControllerName()
            testInfo.rotation = UIDevice.current.orientation.rawValue
            testInfo.screenBase64 = data.base64EncodedString()
            testInfo.deviceModel = ATUtils.modelIdentifier()
            testInfo.viewControllerStateDataJson = VCModelJson?.data(using: .utf8)?.prettyUtf8LogString ?? ""
            testInfo.applicationStateDataJson = getGlobalAppStateJson().data(using: .utf8)?.prettyUtf8LogString ?? ""
            testInfo.lang = Locale.current.languageCode ?? ""
            testInfo.hideBackButton = ATUtils.vissibleViewController()?.navigationController?.navigationBar.backItem == nil
            
            IOSAutotestMessageManager.manager.sendSharedMessage(message: testInfo.ToJson(), ClientMessageType: "GetTestDataResponse", targetClientId: "c#_AutotestBackend_client1")
            
        } else if message.ClientMessageType == "RunTestCase" {
            ELTestableViewController.testModeDisabled = false
            let testInfo = message.testScreenData()
            print("gotSharedMessage RunTestCase \(testInfo.testName)")
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
        }
    }
    
    func runTestCaseWithStateJson(testInfo: TestScreenData) {
        print("runTestCaseWithStateJson \(testInfo.testName)")
        let testedViewControllerClass = NSClassFromString("ELIOSAutoTest." + testInfo.viewControllerName!) as! ELTestableViewController.Type
        let testedViewController = testedViewControllerClass.loadViewControllerFromXib()

        loadGlobalAppStateJson(json: testInfo.applicationStateDataJson ?? "")
        UIDevice.current.setValue(testInfo.rotation, forKey: "orientation")
        testedViewController.loadModelJson(json: testInfo.viewControllerStateDataJson ?? "{}")
        pushTestedViewController(testedViewController: testedViewController, hideBackButton: testInfo.hideBackButton)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let data = ELTestableViewController.captureScreenshot()! // let it fall
//            testInfo.screenBase64 = data.base64EncodedString()
            testInfo.screenBase64 = IOSAutotestMessageManager.str.replacingOccurrences(of: "1", with: "\(IOSAutotestMessageManager.index)")
            
           
            IOSAutotestMessageManager.index += 1
            print("current index \(IOSAutotestMessageManager.index)")
            
            
            testInfo.rotation = UIDevice.current.orientation.rawValue
            testInfo.deviceModel = ATUtils.modelIdentifier()
            testInfo.viewControllerStateDataJson = "{}"
            testInfo.lang = Locale.current.languageCode ?? ""
            
            IOSAutotestMessageManager.manager.sendSharedMessage(message: testInfo.ToJson(), ClientMessageType: "RunTestCaseResponse", targetClientId: "c#_AutotestBackend_client1")
        }
    }
    static var index = 0
    static var str = """
a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1
"""
}
