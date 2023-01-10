//
//  ELPRequestClientMessageManager.swift
//  SocketClient
//
//  Created by EVGENII Loshchenko on 11.07.2022.
//

import UIKit

class ResponseJson {
    var error: String?
    var fileLink: String?
}

class ELPRequestClientMessageManager: NSObject {
    
    var client: ELPRequestClient!
    
    var IP = "46.49.118.172"
    var clientId = "Example_ios_client_name"
    var HttpApiKey = "ExampleHttpApi"
    var SharedApiKey = "ExampleSharedApi"
    var port: UInt32 = 5201
    
    func start() {
        self.client.StartClient(http: false, shared: true)
    }
    
    override init() {
        super.init()
        self.client = ELPRequestClient()
        self.client.messageManager = self
    }
    
    func gotSharedMessage(message: ELPClientResponseMessage, data: Data) {
        print("gotSharedMessage")
        print("\(message.Response)")
    }
    
    //http://localhost:5300/forumApi/Page/FileName
    static func page(_ requestObject: ELPClientRequestObject) -> String {
        return ELProxyUtils.pathElement(requestObject: requestObject, index: 2)
    }
    
    func respondToMessage(requestObject: ELPClientRequestObject) -> String {
//        let page = ELPRequestClientMessageManager.page(requestObject)
        let responseMessage = ELPClientResponseMessage(requestObject.requestInfo?.RequestIndex ?? "", HttpApiKey)
        return responseMessage.updateResponse("test ios response 3")
    }
    
    func sendSharedMessage(message: String, ClientMessageType: String, targetClientId: String?) {
        let responseMessage = ELPClientResponseMessage("", SharedApiKey)
        responseMessage.Response = message
        responseMessage.MessageType = ELPRequestMessage.sharedApiData
        responseMessage.ApiKey = SharedApiKey
        responseMessage.ClientId = clientId
        responseMessage.ClientMessageType = ClientMessageType
        responseMessage.TargetClientId = targetClientId
        self.client?.sendDataAsMessage(stringData: responseMessage.ToJson())
    }
    
}
