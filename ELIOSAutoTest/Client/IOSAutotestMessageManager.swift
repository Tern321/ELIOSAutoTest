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
        if (openPorts) {
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
    
    override func gotSharedMessage(message: ELPClientResponseMessage, data: Data) {
        print("test")
        if message.ClientMessageType == "GetTestData" {
            
            let data = RootViewController.shared?.captureScreenshot()
            
            var testInfo = try! JSONDecoder().decode(TestScreenData.self, from: message.Response!.data(using: .utf8)!)
            testInfo.viewControllerName = "RootViewController";
            testInfo.rotation = "v"
            testInfo.screenBase64 = data!.base64EncodedString()
            testInfo.deviceModel = modelIdentifier()
            testInfo.viewControllerModelJson = "{}"
            testInfo.lang = Locale.current.languageCode ?? "";
//            testInfo
            RootViewController.shared?.manager.sendSharedMessage(message: testInfo.ToJson(), ClientMessageType: "GetTestDataResponse")
            
            // send viewController info and image and device data
        } else if message.ClientMessageType == "RunTestCase" {
            // get Data, run test, send message
            let data = RootViewController.shared?.captureScreenshot()
            
            var testInfo = try! JSONDecoder().decode(TestScreenData.self, from: message.Response!.data(using: .utf8)!)
            testInfo.viewControllerName = "RootViewController";
            testInfo.rotation = "v"
            testInfo.screenBase64 = data!.base64EncodedString()
            testInfo.deviceModel = modelIdentifier()
//            testInfo.viewControllerModelJson = "{}"
            testInfo.lang = Locale.current.languageCode ?? "";
//            testInfo
            RootViewController.shared?.manager.sendSharedMessage(message: testInfo.ToJson(), ClientMessageType: "RunTestCaseResponse")
            
        }
//        if message.MessageType
//        if let message = try? JSONDecoder().decode(ELPClientResponseMessage.self, from: corrected.base64DecodedBytes!) {
//            messageManager.gotSharedMessage(message: message, data:corrected.base64DecodedBytes!)
//        }
        
    }
}
