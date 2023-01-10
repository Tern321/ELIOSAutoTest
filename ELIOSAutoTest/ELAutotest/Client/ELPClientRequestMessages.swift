//
//  ELPClientRequestMessages.swift
//  SocketClient
//
//  Created by EVGENII Loshchenko on 11.07.2022.
//

import Foundation

class ELPRequestMessage: NSObject, Codable {
    
    internal init(ClientId: String? = nil, RequestIndex: String? = nil, ApiKey: String? = nil, MessageType: String? = nil) {
        self.ClientId = ClientId
        self.RequestIndex = RequestIndex
        self.ApiKey = ApiKey
        self.MessageType = MessageType
    }
    
    static var sharedApiData = "sharedApiData"
    static var requestMessage = "requestMessage"
    static var apiMessage = "apiMessage"
    static var sharedApiMessage = "sharedApiMessage"
    
    var ClientId: String?
    var RequestIndex: String?
    var ApiKey: String?
    var MessageType: String?
    
    var response: String?
    
    public func ToJson() -> String {
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(self)
        return String(data: jsonData ?? Data(), encoding: String.Encoding.utf8) ?? ""
    }
    
    public class ApiKeyMessage {
        var apiKey: String?
    }
    
    public func isSharedApiMessage() -> Bool {
        return MessageType == ELPRequestMessage.sharedApiMessage
    }
    
    public func  isApiKeyMessage() -> Bool {
        return MessageType == ELPRequestMessage.apiMessage
    }
}

class ELPClientResponseMessage: Codable {
    
    var RequestIndex: String?
    var ApiKey: String?
    var Response: String?
    var MessageType: String?
    var ClientId: String?
    var TargetClientId: String?
    
    var ClientMessageType: String?
    var ClientMessageData: String?
    
    func testScreenData() -> TestScreenData {
        let corrected = Response!.replacingOccurrences(of: "\n", with: "", options: .literal, range: nil)
        let problemJson = String(bytes: corrected.base64DecodedBytes!, encoding: .utf8)!
        return try! JSONDecoder().decode(TestScreenData.self, from: Data(problemJson.utf8))
    }
    init(_ requestIndex: String, _ apiKey: String) {
            RequestIndex = requestIndex
            ApiKey = apiKey
        }
    
        func ToJson() -> String {
            let jsonEncoder = JSONEncoder()
            let jsonData = try? jsonEncoder.encode(self)
            return String(data: jsonData ?? Data(), encoding: String.Encoding.utf8) ?? ""
        }
    
        func updateResponse(_ response: Data) -> String {
            self.Response = response.base64EncodedString()
            return ToJson()
            
        }
    
        func updateResponse(_ response: String) -> String {
            return updateResponse(response.data(using: .utf8) ?? Data())
        }
}

class ELPRequestInfo: Decodable {
    var RequestIndex: String?
    var Path: String?
}

class ELPClientRequestObject {
    var requestInfo: ELPRequestInfo?
    
    var bodyBytes: Data?
    
    func requestBody() -> String {
        return String(data: bodyBytes ?? Data(), encoding: .utf8) ?? ""
    }
    
    init(message: String) {
        let arr = message.components(separatedBy: ELProxyUtils.middleOfMessage)
//        if arr.count > 1 {
        bodyBytes = arr[1].base64DecodedBytes
        requestInfo = try? JSONDecoder().decode(ELPRequestInfo.self, from: (arr[0].base64DecodedBytes ?? Data()))
//        }
    }
}
